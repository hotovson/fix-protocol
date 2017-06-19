module Fix
  module Protocol
    module Messages
      #
      # A sequence reset message which allows a peer to not retransmit administrative
      # messages in response to resend request. It also enables one to reset the sequence
      # number to any integer larger than the currently expected sequence number
      #
      class SequenceReset < Message
        # common fields
        field :app_ver_id,      tag: 1128
        field :sender_comp_id,  tag: 49,    required: true
        field :target_comp_id,  tag: 56,    required: true
        field :msg_seq_num,     tag: 34,    required: true, type: :integer
        field :sending_time,    tag: 52,    required: true, type: :timestamp, default: proc { Time.now.utc }

        field :gap_fill_flag,   tag: 123, type: :yn_bool, default: false
        field :new_seq_no,      tag: 36,  type: :integer, required: true
      end
    end
  end
end
