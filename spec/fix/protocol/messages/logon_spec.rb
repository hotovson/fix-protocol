require_relative '../../../spec_helper'

describe 'FP::Messages::Logon' do
  context 'a parsed message' do
    before do
      msg = <<-MSG.gsub(/(\n|\s)+/, '')
              8=FIX.4.4\x019=87\x0135=A\x0149=INVMGR\x0156=BRKR\x0134=1\x0152=20000426-12:05:06\x01
              98=0\x01108=30\x01553=USERNAME\x01554=PASSWORD\x0110=193\x01
            MSG
      @parsed = FP.parse(msg)
    end

    it 'should be of the correct type' do
      expect(@parsed).to be_a_kind_of(FP::Messages::Logon)
    end

    it 'should return the correct field values' do
      expect(@parsed.username).to eql('USERNAME')
      expect(@parsed.heart_bt_int).to eql(30)
    end
  end

  describe '#parse' do
    xit 'should return a parse failure when a required field is missing' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '')
              8=FIX.4.4\x019=61\x0135=A\x0149=INVMGR\x0156=BRKR\x0134=1\x0152=20000426-12:05:06\x01
              98=0\x01108=30\x0110=047\x01
            MSG
      parsed = FP.parse(msg)
      expect(parsed).to be_a(FP::ParseFailure)
      expect(parsed.errors).to include('Missing value for <username> field')
    end

    it 'should correctly parse the reset_seq_num_flag as a boolean' do
      msg_true = <<-MSG.gsub(/(\n|\s)+/, '')
                   8=FIX.4.4\x019=109\x0135=A\x0149=DUKENUKEM\x0156=PAYMIUM_DEV\x0134=1\x01
                   52=20141103-15:54:39.130\x0198=0\x01108=30\x01553=JAVA_TESTS\x01554=PASSWORD\x01
                   141=Y\x0110=159\x01
                 MSG
      expect(FP.parse(msg_true).reset_seq_num_flag).to eql(true)

      msg_false = <<-MSG.gsub(/(\n|\s)+/, '')
                    8=FIX.4.4\x019=109\x0135=A\x0149=DUKENUKEM\x0156=PAYMIUM_DEV\x0134=1\x01
                    52=20141103-15:54:39.130\x0198=0\x01108=30\x01553=JAVA_TESTS\x01554=PASSWORD\x01
                    141=N\x0110=148\x01
                  MSG
      expect(FP.parse(msg_false).reset_seq_num_flag).to eql(false)
    end
  end

  describe '#username' do
    it 'should set a body field' do
      m = FP::Messages::Logon.new
      m.username = 'john'
      expect(m.node_for_name('body').node_for_name('username').value).to eql('john')
      expect(m.node_for_name('body').node_for_name('username').tag).to eql(553)
      expect(m.username).to eql('john')
    end
  end

  describe '#validate' do
    before do
      @msg = FP::Messages::Logon.new
    end

    it 'should be invalid' do
      expect(@msg.valid?).to be_falsey
    end

    xit 'should report the lack of username' do
      expect(@msg.errors).to include('Missing value for <username> field')
    end

    xit 'should report the lack of password' do
      expect(@msg.errors).to include('Missing value for <password> field')
    end

    it 'should report the lack of sender_comp_id' do
      expect(@msg.errors).to include('Missing value for <sender_comp_id> field')
    end

    it 'should report the lack of target_comp_id' do
      expect(@msg.errors).to include('Missing value for <target_comp_id> field')
    end
  end

  describe '#dump' do
    it 'should return nil when the message to dump is invalid' do
      expect(FP::Messages::Logon.new.dump).to be_nil
    end

    it 'should generate a proper message string' do
      msg = FP::Messages::Logon.new
      msg.body.sender_comp_id = 'TEST_SENDER'
      msg.body.target_comp_id = 'TEST_TARGET'
      msg.body.msg_seq_num    = 1
      msg.username              = 'TEST_USERNAME'
      msg.password              = 'TEST_PASSWORD'

      expect(msg.dump).to be_a_kind_of(String)
    end

    it 'should correctly dump the reset_seq_num_flag' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '')
              8=FIX.4.4\x019=93\x0135=A\x0149=INVMGR\x0156=BRKR\x0134=1\x0152=20000426-12:05:06\x01
              98=0\x01108=30\x01553=USERNAME\x01554=PASSWORD\x01141=Y\x0110=235\x01
            MSG
      parsed = FP.parse(msg)
      expect(parsed.dump).to match(/141\=Y/)

      parsed.reset_seq_num_flag = false
      expect(parsed.dump).to match(/141\=N/)
    end
  end
end
