module Fix
  module Protocol
    module Messages
      #
      # A FIX resend request message, see http://www.onixs.biz/fix-dictionary/4.4/msgType_2_2.html
      #
      class ResendRequest < Message
        unordered :body do
          # common fields
          field :app_ver_id,      tag: 1128
          field :sender_comp_id,  tag: 49,    required: true
          field :target_comp_id,  tag: 56,    required: true
          field :msg_seq_num,     tag: 34,    required: true, type: :integer
          field :sending_time,    tag: 52,    required: true, type: :timestamp, default: proc { Time.now.utc }

          field :begin_seq_no,  tag: 7,  required: true, type: :integer
          field :end_seq_no,    tag: 16, required: true, type: :integer, default: 0
        end

        #
        # Returns the logon-specific errors
        #
        # @return [Array] The error messages
        #
        def errors
          e = []
          e << 'EndSeqNo must either be 0 (inifinity) or be >= BeginSeqNo' unless end_seq_no_valid?
          [super, e].flatten
        end

        private

        def end_seq_no_valid?
          begin_seq_no && (end_seq_no.zero? || (end_seq_no >= begin_seq_no))
        end
      end
    end
  end
end
