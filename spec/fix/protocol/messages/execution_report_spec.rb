require_relative '../../../spec_helper'

describe 'Fix::Protocol::Messages::ExecutionReport' do
  before do
    @msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
      8=FIX.4.4|9=439|35=8|49=SNDCOMPID|56=TRGCOMPID|34=235|52=20161129-13:50:26.123|50=SNDSUBID|
      115=ONBHLFCOMID|6=123.45|11=CLORDID|14=1245|15=XAU|17=EXECID|18=B|31=11.10|32=500|37=ORDERID|
      38=1000|39=1|40=1|41=ORIGCLID|44=11.12|54=1|55=XAU/USD|58=SOMETEXT|59=0|
      60=20161129-13:50:26.159|64=20161129|75=20161128|103=99|110=0|119=20|120=XAU|
      126=20161130-23:59:59.999|150=1|151=49|167=FOR|168=20161129-13:50:26.123|38=0|194=11.00|
      195=0.11|460=4|541=20161130|555=0|10=111|
    MSG
  end

  it 'properly parse valid message' do
    puts FP.parse(@msg).errors
    expect(FP.parse(@msg)).to be_a_kind_of(FP::Messages::ExecutionReport)
  end

  it '#dump should return the same message' do
    expect(FP.parse(@msg).dump).to eql(@msg)
  end
end
