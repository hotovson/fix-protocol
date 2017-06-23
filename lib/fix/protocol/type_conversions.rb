require 'bigdecimal'

module Fix
  module Protocol
    #
    # Defines helper methods to convert to and from FIX data types
    #
    module TypeConversions
      #
      # Parses a FIX-formatted timestamp into a Time instance, milliseconds are discarded
      #
      # @param str [String] A FIX-formatted timestamp
      # @return [Time] An UTC date and time
      #
      TIMESTAMP_REGEX = /\A([0-9]{4})([0-9]{2})([0-9]{2})-([0-9]{2}):([0-9]{2}):([0-9]{2})(.[0-9]{3})?\Z/
      def parse_timestamp(str)
        m = str.match(TIMESTAMP_REGEX).to_a.map(&:to_i)
        Time.utc(m[1], m[2], m[3], m[4], m[5], m[6], 0) if m.any?
      end

      #
      # Outputs a DateTime object as a FIX-formatted timestamp
      #
      # @param dt [DateTime] An UTC date and time
      # @return [String] A FIX-formatted timestamp
      #
      def dump_timestamp(dt)
        dt.utc.strftime('%Y%m%d-%H:%M:%S')
      end

      LOCAL_MARKET_DATE_REGEX = /\A([0-9]{4})([0-9]{2})([0-9]{2})\Z/
      def parse_local_market_date(str)
        m = str.match(LOCAL_MARKET_DATE_REGEX).to_a.map(&:to_i)
        Time.utc(m[1], m[2], m[3]) if m.any?
      end

      def dump_local_market_date(dt)
        dt.utc.strftime('%Y%m%d')
      end

      #
      # Parses an integer
      #
      # @param str [String] An integer as a string
      # @return [Fixnum] The parsed integer
      #
      def parse_integer(str)
        str && str.to_i
      end

      #
      # Dumps an integer to a string
      #
      # @param i [Fixnum] An integer
      # @return [String] It's string representation
      #
      def dump_integer(i)
        i.to_s
      end

      #
      # Dumps a boolean to a Y/N FIX string
      #
      # @param b [Boolean] A boolean
      # @return [String] 'Y' if the parameter is true, 'N' otherwise
      #
      def dump_yn_bool(b)
        b ? 'Y' : 'N'
      end

      #
      # Parses a string into a boolean value
      #
      # @param str [String] The string to parse
      # @return [Boolean] +true+ if the string is 'Y', +false+ otherwise
      #
      def parse_yn_bool(str)
        str == 'Y'
      end

      def parse_price(str)
        str && BigDecimal.new(str)
      end

      def dump_price(price)
        price.to_f.to_s
      end

      def parse_qty(str)
        str && str.to_i
      end

      def dump_qty(qty)
        qty.to_s
      end

      def parse_amt(str)
        str && BigDecimal.new(str)
      end

      def dump_amt(amt)
        amt.to_s
      end
    end
  end
end
