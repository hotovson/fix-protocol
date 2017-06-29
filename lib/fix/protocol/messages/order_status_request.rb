module Fix
  module Protocol
    module Messages
      class OrderStatusRequest < Message
        unordered :body do
          # common fields
          field :app_ver_id,      tag: 1128
          field :sender_comp_id,  tag: 49,    required: true
          field :target_comp_id,  tag: 56,    required: true
          field :msg_seq_num,     tag: 34,    required: true, type: :integer
          field :sending_time,    tag: 52,    required: true, type: :timestamp, default: proc { Time.now.utc }

          field :sender_sub_id, tag: 50
          field :deliver_to_comp_id, tag: 128, required: true
          # defined in protocol, but server reject this
          # field :party_id,      tag: 448, required: true
          field :cl_ord_id,     tag: 11, required: true
          field :order_id,      tag: 37
        end
      end
    end
  end
end
