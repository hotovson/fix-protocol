require 'fix/protocol/version'
require 'fix/protocol/messages'
require 'fix/protocol/message_class_mapping'
require 'fix/protocol/parse_failure'

#
# Main Fix namespace
#
module Fix
  #
  # Main protocol namespace
  #
  module Protocol
    #
    # The default version of the protocol to use
    #
    DEFAULT_FIX_PROTOCOL_VERSION = 'FIX.4.4'.freeze

    #
    # Parses a string into a Fix::Protocol::Message instance
    #
    # @param str [String] A FIX message string
    # @return [Fix::Protocol::Message] A +Fix::Protocol::Message+ instance, or a +Fix::Protocol::ParseFailure+
    # in case of failure
    #
    MSG_REGEX = /(^8\=[^\x01]+\x019\=([^\x01]+)\x01(35\=([^\x01]+)\x01.+))10\=([^\x01]+)\x01$/
    # m[1] msg without checksum
    # m[2] msg length as string
    # m[3] msg body
    # m[4] msg type
    # m[5] msh checksum

    def self.parse(str)
      errors = []
      m = str.match(MSG_REGEX).to_a

      if m.any?
        klass = MessageClassMapping.get(m[4])
        errors << "Unknown message type <#{m[4]}>" unless klass

        # Check message length
        errors << "Incorrect body length, expected <#{m[3].length}>, got <#{m[2].to_i}>" if m[3].length != m[2].to_i

        # Check checksum
        expected = format('%03d', m[1].bytes.inject(&:+) % 256)
        errors << "Incorrect checksum, expected <#{expected}>, got <#{m[5]}>" if m[5] != expected

        if errors.empty?
          msg = klass.parse(str)

          if msg.valid?
            msg
          else
            FP::ParseFailure.new(msg.errors)
          end
        else
          FP::ParseFailure.new(errors)
        end
      else
        FP::ParseFailure.new("Malformed message <#{str}>")
      end
    end

    #
    # Alias the +Fix::Protocol+ namespace to +FP+ if possible
    #
    def self.alias_namespace!
      Object.const_set(:FP, Protocol) unless Object.const_defined?(:FP)
    end

    #
    # Formats a symbol as a proper class name
    #
    # @param s [Symbol] A name to camelcase
    # @return [Symbol] A camelcased class name
    #
    def self.camelcase(s)
      s.to_s.split(' ').map { |str| str.split('_') }.flatten.map(&:capitalize).join.to_sym
    end

    #
    # Sets up the autoloading mechanism according to the relevant FIX version
    #
    def self.setup_autoload!
      ver = defined?(FIX_PROTOCOL_VERSION) ? FIX_PROTOCOL_VERSION : DEFAULT_FIX_PROTOCOL_VERSION
      folder = File.join(File.dirname(__FILE__), "protocol/messages/#{ver.delete('.').downcase}")

      Dir["#{folder}/*.rb"].each do |file|
        klass = camelcase(file.match(%r{([^\/]+)\.rb$})[1])
        Messages.autoload(klass, file)
      end
    end
  end
end

Fix::Protocol.alias_namespace!
Fix::Protocol.setup_autoload!

require 'fix/protocol/message'
