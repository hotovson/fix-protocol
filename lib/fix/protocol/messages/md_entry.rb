module Fix
  module Protocol
    module Messages
      #
      # A market data entry
      #
      class MdEntry < MessagePart
        #
        # The MD entry type mapping
        #
        MD_ENTRY_TYPES = {
          bid:            0,
          ask:            1,
          trade:          2,
          index:          3,
          open:           4,
          close:          5,
          settlement:     6,
          high:           7,
          low:            8,
          vwap:           9,
          imbalance:      'A',
          volume:         'B',
          open_interest:  'C'
        }.freeze

        #
        # The update actions when updating a market data entry
        #
        MD_UPDATE_ACTIONS = {
          new:    0,
          change: 1,
          delete: 2
        }.freeze

        field :update_action,         tag: 279, mapping: MD_UPDATE_ACTIONS
        field :md_entry_type,         tag: 269, required: true, mapping: MD_ENTRY_TYPES
        field :md_entry_px,           tag: 270
        field :currency,              tag: 15
        field :md_entry_size,         tag: 271
        field :quote_condition,       tag: 276
        field :md_entry_originator,   tag: 282
        field :min_qty,               tag: 110
        field :quote_entry_id,        tag: 299
        field :md_entry_position_no,  tag: 290
      end
    end
  end
end

