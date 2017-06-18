module Fix
  module Protocol
    module Messages
      class NewOrderSingle < Message
        EXEC_INST_TYPES = {
          ok_to_cross: 'B',
          best_price: 'P'
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

        unordered :body do
          field :sender_sub_id, tag: 50
          field :cl_ord_id,     tag: 11, required: true
          field :currency,      tag: 15, required: true
          field :exec_inst,     tag: 18, required: true, mapping: EXEC_INST_TYPES
          field :handl_inst,    tag: 21
          field :order_qty,     tag: 38, required: true, type: :qty
          field :ord_type,      tag: 40, required: true, mapping: ORDER_TYPE_TYPES
          field :side,          tag: 54, required: true
          field :symbol,        tag: 55, required: true
          field :time_in_force, tag: 59, required: true, mapping: TIME_IN_FORCE_TYPES
          field :transact_time, tag: 60, required: true, type: :timestamp, default: proc { Time.now.utc }
          field :min_qty,       tag: 110, required: true, type: :qty
          field :security_type, tag: 167, required: true
          field :product,       tag: 460, required: true, type: :integer
        end
      end
    end
  end
end
