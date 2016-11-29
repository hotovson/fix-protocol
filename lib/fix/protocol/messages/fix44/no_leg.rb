module Fix
  module Protocol
    module Messages
      class NoLeg < UnorderedPart
        LEG_SIDE_TYPES = {
          buy: '1',
          sell: '2'
        }.freeze

        field :leg_symbol, tag: 600, required: true
        field :leg_side, tag: 624, required: true, mapping: LEG_SIDE_TYPES
        field :leg_currency, tag: 556, required: true
        field :leg_ref_id, tag: 654, required: true
        field :leg_price, tag: 566, type: :price
        field :leg_sett_date, tag: 588, required: true, type: :local_market_date
        field :leg_exec_id, tag: 1893
      end
    end
  end
end
