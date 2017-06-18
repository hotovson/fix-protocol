module Fix
  module Protocol
    module Messages
      class OrderStatusRequest < Message
        unordered :body do
          field :sender_sub_id, tag: 50
          field :deliver_to_comp_id, tag: 128, required: true
          # defined in protocol, but server reject this
          # field :party_id,      tag: 448, required: true
          field :cl_ord_id,     tag: 11, required: true
          field :order_id,      tag: 37, required: true
        end
      end
    end
  end
end
