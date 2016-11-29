require_relative '../../../spec_helper'

describe 'Fix::Protocol::Messages::NewOrderSingle' do
  before do
    @msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
      8=FIX.4.4|9=177|35=D|49=SNDCOMPID|56=TRGCOMPID|34=235|52=20161129-13:50:26.123|50=SNDSUBID|
      11=CLORDID|15=XAU|18=B|38=1000|40=1|54=1|55=XAU/USD|59=0|60=20161129-13:50:26.159|110=0|
      167=FOR|460=4|10=052|
    MSG
  end

  it 'properly parse valid message' do
    expect(FP.parse(@msg)).to be_a_kind_of(FP::Messages::NewOrderSingle)
  end

  it '#dump should return the same message' do
    expect(FP.parse(@msg).dump).to eql(@msg)
  end
end
