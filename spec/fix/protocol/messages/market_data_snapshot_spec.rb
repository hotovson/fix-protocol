require_relative '../../../spec_helper'

describe Fix::Protocol::Messages::MarketDataSnapshot do

  before do
    @mds = "8=FIX.4.4\x019=121\x0135=W\x0149=MY_ID\x0156=MY_COUNTERPARTY\x0134=85\x0152=20141022-10:53:35\x01262=PAPA-TANGO-PAPA\x0155=EUR/XBT\x01268=1\x01269=1\x01270=412.54\x01271=45\x0110=222\x01"
  end

  describe '#dump' do
    it 'should return the same market data snapshot that was parsed' do
      expect(FP.parse(@mds).dump).to eql(@mds)
    end
  end

  describe '.parse' do
    it 'should correctly parse a message' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
          8=FIX.4.4|9=255|35=W|34=144|49=prod.fx|52=20200608-08:04:43.067|56=quote.ld.001|57=ld5|55=XAU/USD|262=3|460=4|541=20200610|268=2|269=0|270=1695.42|15=XAU|271=100|276=A|282=INTM|299=1082486_BID|290=1|269=1|270=1696.08|15=XAU|271=100|276=A|282=INTM|299=1082486_OFFER|290=1|10=216|
      MSG
      snapshot = FP.parse(msg)
      expect(snapshot).to be_an_instance_of(FP::Messages::MarketDataSnapshot)

      expect(snapshot.md_entries.size).to eq 2
      expect(snapshot.md_entries[0].md_entry_type).to eq :bid
      expect(snapshot.md_entries[0].md_entry_px).to eq '1695.42'
      expect(snapshot.md_entries[1].md_entry_type).to eq :ask
      expect(snapshot.md_entries[1].md_entry_px).to eq '1696.08'
    end

    it 'parses a message without the 541 tag' do
      msg = <<-MSG.gsub(/(\n|\s)+/, '').tr('|', "\x01")
          8=FIX.4.4|9=297|35=W|34=6|49=prod.fxgrid|52=20200608-10:27:49.745|56=quote.LDNMT0264INTM.001|57=LDNMT0264INTM|55=XAU/CZK|262=1|460=4|268=2|269=0|270=0|15=XAU|271=0|276=B|282=INTM|299=G-3c369d34-1729378d771-INTM-5f3_BID|290=0|269=1|270=0|15=XAU|271=0|276=B|282=INTM|299=G-3c369d34-1729378d771-INTM-5f3_OFFER|290=0|10=215|
      MSG
      expect(FP.parse(msg)).to be_an_instance_of(FP::Messages::MarketDataSnapshot)
    end

  end

end
