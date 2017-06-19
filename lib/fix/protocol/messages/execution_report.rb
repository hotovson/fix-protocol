require 'fix/protocol/messages/no_leg'

module Fix
  module Protocol
    module Messages
      class ExecutionReport < Message
        EXEC_INST_TYPES = {
          ok_to_cross: 'B',
          best_price: 'P'
        }.freeze

        ORDER_STATUS_TYPES = {
          pending_new: 'A',
          new: '0',
          accepted: 'D',
          partial_fill: '1',
          filled: '2',
          stopped: '7',
          rejected: '8',
          expired: 'C',
          cancelled: '4',
          replaced: '5',
          pending_cancel: '6',
          pending_replace: 'E'
        }.freeze

        ORDER_TYPE_TYPES = {
          market: '1',
          limit:  '2',
          stop:   '3',
          stop_limit: '4',
          previously_quoted: 'D'
        }.freeze

        TIME_IN_FORCE_TYPES = {
          day: '0',
          gtc: '1',
          ioc: '3',
          fok: '4',
          gtd: '6'
        }.freeze

        ORD_REJ_REASON_TYPES = {
          broker_exchange_option: 0,
          unknown_symbol:         1,
          exchange_closed:        2,
          order_exceeds_limit:    3,
          too_late_to_enter:      4,
          unknown_order:          5,
          duplicate_order:        6,
          duplicate_verbally_order: 7,
          stale_order:            8,
          trade_along_required:   9,
          invalid_investor_id:    10,
          unsupported_order_characteristic: 11,
          surveillance_option:    12,
          incorrect_quantity:     13,
          incorrect_allocated_quantity: 14,
          unknown_account:        15,
          other:                  99
        }.freeze

        unordered :body do
          # common fields
          field :app_ver_id,      tag: 1128
          field :sender_comp_id,  tag: 49,    required: true
          field :target_comp_id,  tag: 56,    required: true
          field :msg_seq_num,     tag: 34,    required: true, type: :integer
          field :sending_time,    tag: 52,    required: true, type: :timestamp, default: proc { Time.now.utc }

          field :sender_sub_id, tag: 50
          field :on_behalf_of_comp_id, tag: 115 #, required: true
          field :avg_px,        tag: 6, required: true, type: :price
          field :cl_ord_id,     tag: 11, required: true
          field :cum_qty,       tag: 14, required: true, type: :qty
          field :currency,      tag: 15, required: true
          field :exec_id,       tag: 17, required: true
          field :exec_inst,     tag: 18, required: true, mapping: EXEC_INST_TYPES
          field :last_px,       tag: 31, type: :price
          field :last_qty,      tag: 32, type: :qty
          field :order_id,      tag: 37, required: true
          field :order_qty,     tag: 38, required: true, type: :qty
          field :ord_status,    tag: 39, required: true, mapping: ORDER_STATUS_TYPES
          field :ord_type,      tag: 40, required: true, mapping: ORDER_TYPE_TYPES
          field :orig_cl_ord_id, tag: 41
          field :price,         tag: 44, type: :price #, required: true
          field :side,          tag: 54, required: true
          field :symbol,        tag: 55, required: true
          field :text,          tag: 58
          field :time_in_force, tag: 59, required: true, mapping: TIME_IN_FORCE_TYPES
          field :transact_time, tag: 60, required: true, type: :timestamp
          field :fut_sett_date, tag: 64, type: :local_martket_date
          field :trade_date,    tag: 75, type: :local_martket_date
          field :ord_rej_reason, tag: 103, type: :integer, mapping: ORD_REJ_REASON_TYPES
          field :min_qty,       tag: 110, type: :qty
          field :settl_curr_amt, tag: 119
          field :settl_currency, tag: 120
          field :expire_time,   tag: 126, type: :timestamp
          field :exec_type,     tag: 150, required: true
          field :leaves_qty,    tag: 151, required: true, type: :qty
          field :security_type, tag: 167, required: true
          field :effective_time, tag: 168, type: :timestamp
          field :order_qty_2,   tag: 38, type: :qty
          field :last_spot_rate, tag: 194, type: :price
          field :last_forward_points, tag: 195, type: :price
          field :product,       tag: 460, required: true, type: :integer
          field :maturity_date, tag: 541, type: :local_martket_date

          collection :no_legs, counter_tag: 555, klass: FP::Messages::NoLeg
        end
      end
    end
  end
end
