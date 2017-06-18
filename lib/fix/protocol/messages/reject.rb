module Fix
  module Protocol
    module Messages
      #
      # A FIX session reject message
      #
      class Reject < Message
        unordered :body do
          field :ref_seq_num, tag: 45, required: true, type: :integer
          field :text,        tag: 58
          field :ref_tag_id,  tag: 371, type: :integer
          field :ref_msg_type, tag: 372
        end
      end
    end
  end
end
