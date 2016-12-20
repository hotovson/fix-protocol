module Fix
  module Protocol
    FIX_PROTOCOL_VERSION = :fix43
    BEGIN_STRING = 'FIX.4.3'.freeze
  end
end

require 'fix/protocol'
