require 'fix/protocol/messages/md_entry_type'
require 'fix/protocol/messages/instrument'

module Fix
  module Protocol
    module Messages
      #
      # A FIX market data request message
      #
      class MarketDataRequest < Message
        #
        # The subscription type, see: http://www.onixs.biz/fix-dictionary/4.4/tagNum_263.html
        #
        SUBSCRIPTION_TYPES = {
          snapshot:     0,
          updates:      1,
          unsubscribe:  2
        }.freeze

        #
        # Whether to return the full book or only the best bid/ask
        #
        MKT_DPTH_TYPES = {
          full: 0,
          top:  1
        }.freeze

        #
        # Whether to send a full market depth on each update, we'll probably only support the incremental type
        #
        UPDATE_TYPES = {
          full:         0,
          incremental:  1
        }.freeze

        unordered :body do
          # common fields
          field :app_ver_id,      tag: 1128
          field :sender_comp_id,  tag: 49,    required: true
          field :target_comp_id,  tag: 56,    required: true
          field :msg_seq_num,     tag: 34,    required: true, type: :integer
          field :sending_time,    tag: 52,    required: true, type: :timestamp, default: proc { Time.now.utc }

          field :sender_sub_id,             tag: 50
          field :deliver_to_comp_id,        tag: 128
          field :md_req_id,                 tag: 262, required: true
          field :subscription_request_type, tag: 263, required: true, type: :integer, mapping: SUBSCRIPTION_TYPES
          field :market_depth,              tag: 264, required: true, type: :integer, mapping: MKT_DPTH_TYPES
          field :md_update_type,            tag: 265, required: true, type: :integer, mapping: UPDATE_TYPES

          collection :md_entry_types, counter_tag: 267, klass: FP::Messages::MdEntryType
          collection :instruments,    counter_tag: 146, klass: FP::Messages::Instrument
        end

        #
        # Check that the collections aren't empty
        #
        def errors
          errs = []

          errs << 'MdEntryTypes can not be empty' if md_entry_types.empty?
          errs << 'Instruments can not be empty'  if instruments.empty?

          [super, errs].flatten
        end
      end
    end
  end
end
