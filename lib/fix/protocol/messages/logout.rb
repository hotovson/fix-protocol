module Fix
  module Protocol
    module Messages
      #
      # A FIX session reject message
      #
      class Logout < Message
        # common fields
        unordered :body do
          field :app_ver_id,      tag: 1128
          field :sender_comp_id,  tag: 49,    required: true
          field :target_comp_id,  tag: 56,    required: true
          field :msg_seq_num,     tag: 34,    required: true, type: :integer
          field :sending_time,    tag: 52,    required: true, type: :timestamp, default: proc { Time.now.utc }

          field :text, tag: 58
        end
      end
    end
  end
end
