require_relative '../../../spec_helper'

describe 'Fix::Protocol::Messages::TestRequest' do
  before do
    @msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
      8=FIX.4.3|9=85|35=1|34=360|49=demo.fxgrid|52=20170630-01:48:58.424|56=order.ORODGC0008.001|112=TEST|10=064|
    MSG
  end

  it 'properly parse valid message' do
    FP::Message.version = 'FIX.4.3'
    expect(FP.parse(@msg)).to be_a_kind_of(FP::Messages::TestRequest)
    FP::Message.version = 'FIX.4.4'
  end
end
