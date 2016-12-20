module Fix
  module Protocol
    FIX_PROTOCOL_VERSION = :fix44
    BEGIN_STRING = 'FIX.4.4'.freeze
  end
end

require 'fix/protocol'
