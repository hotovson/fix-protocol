require 'fix/protocol/message_part'
require 'fix/protocol/unordered_part'

module Fix
  module Protocol
    module Messages
      #
      # The header fields of a message
      #
      class HeaderFields < UnorderedPart
        field :msg_type,        tag: 35,    required: true
      end
    end
  end
end
