require_relative '../../spec_helper'

describe Fix::Protocol::Message do
  before do
    @heartbeat = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
      8=FIX.4.1|9=73|35=0|49=BRKR|56=INVMGR|34=235|52=19980604-07:58:28|112=19980604-07:58:28|10=235|
    MSG
  end

  describe '#msg_seq_num' do
    xit 'should be delegated to the message header' do
      hb = FP::Messages::Heartbeat.new
      expect(hb.header).to receive(:msg_seq_num=).once.with(42).and_call_original
      expect(hb.header).to receive(:msg_seq_num).once.and_call_original
      hb.msg_seq_num = 42
      expect(hb.msg_seq_num).to eql(42)
    end
  end

  describe '.parse' do
    it 'should return a failure when failing to parse a message' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FOO.4.2|9=73|35=XyZ|49=BRKR|56=INVMGR|34=235|52=19980604-07:58:28|112=19980604-07:58:28|10=235|
      MSG
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
    end

    it 'should return a failure when the version is not expected' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FOO.4.2|9=73|35=0|49=BRKR|56=INVMGR|34=235|52=19980604-07:58:28|112=19980604-07:58:28|10=233|
      MSG
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include('Unsupported version: <FOO.4.2>, expected <FIX.4.4>')
    end

    it 'should not return a failure when the version is expected' do
      FP::Message.version = 'FOO.4.2'
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FOO.4.2|9=73|35=0|49=BRKR|56=INVMGR|34=235|52=19980604-07:58:28|112=19980604-07:58:28|10=233|
      MSG
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::Message)
      FP::Message.version = 'FIX.4.4'
    end

    it 'should return a failure when the message type is incorrect' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FOO.4.2|9=73|35=ZOULOU|49=BRKR|56=INVMGR|34=235|52=19980604-07:58:28|112=19980604-07:58:28|10=235|
      MSG
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include('Unknown message type <ZOULOU>')
    end

    it 'should return a failure when the checksum is incorrect' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FOO.4.2|9=73|35=0|49=BRKR|56=INVMGR|34=235|52=19980604-07:58:28|112=19980604-07:58:28|10=235|
      MSG
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include('Incorrect checksum, expected <233>, got <235>')
    end

    it 'should return a failure when the body length is incorrect' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FOO.4.2|9=73|35=0|49=BRKR|56=INVMGR|34=235|52=19980604-07:58:28|112= <additionnal length> 19980604-07:58:28|10=235|
      MSG
      failure = Fix::Protocol.parse(msg)
      expect(failure).to be_a_kind_of(Fix::Protocol::ParseFailure)
      expect(failure.errors).to include('Incorrect body length, expected <92>, got <73>')
    end

    it 'should parse a message to its correct class' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FIX.4.4|9=74|35=0|49=AAAA|56=BBB|34=2|52=20080420-15:16:13|112=L.0001.0002.0003.151613|10=034|
      MSG
      expect(Fix::Protocol.parse(msg)).to be_a_kind_of(Fix::Protocol::Messages::Heartbeat)
    end
  end

  context 'when a message has been parsed' do
    before do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
        8=FIX.4.4|9=74|35=0|49=AAAA|56=BBB|34=2|52=20080420-15:16:13|112=L.0001.0002.0003.151613|10=034|
      MSG
      @parsed = FP.parse(msg)
    end

    describe '#sender_comp_id' do
      it 'should return a value if the tag is present' do
        expect(@parsed.body.sender_comp_id).to eq('AAAA')
      end
    end

    describe '#sending_time' do
      it 'should set the default value if relevant' do
        expect(FP::Messages::Heartbeat.new.body.sending_time).to be_a_kind_of(Time)
      end
    end

    describe '#version' do
      it 'should return the default value if relevant' do
        expect(FP::Messages::Heartbeat.new.header.version).to eql('FIX.4.4')
      end
    end
  end
end
