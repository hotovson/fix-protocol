module Fix
  module Protocol
    module Messages
      #
      # A FIX logon message
      #
      class Logon < Message
        unordered :body do
          # common fields
          field :app_ver_id,      tag: 1128
          field :sender_comp_id,  tag: 49,    required: true
          field :target_comp_id,  tag: 56,    required: true
          field :msg_seq_num,     tag: 34,    required: true, type: :integer
          field :sending_time,    tag: 52,    required: true, type: :timestamp, default: proc { Time.now.utc }

          field :encrypt_method,      tag: 98,  required: true, type: :integer, default: 0
          field :heart_bt_int,        tag: 108, required: true, type: :integer, default: 30
          field :username,            tag: 553 #, required: true
          field :password,            tag: 554 #, required: true
          field :reset_seq_num_flag,  tag: 141, type: :yn_bool, default: false
        end

        #
        # Returns the logon-specific errors
        #
        # @return <Array> The error messages
        #
        def errors
          e = []
          e << "Encryption is not supported, the transport level should handle it" unless (encrypt_method == 0)
          e << "Heartbeat interval should be between 10 and 60 seconds"            unless heart_bt_int && heart_bt_int <= 60 && heart_bt_int >= 10
          [super, e].flatten
        end
      end
    end
  end
end
