require_relative '../../spec_helper'

require 'bigdecimal'

describe 'Fix::Protocol::TypeConversions' do
  class Test
    include FP::TypeConversions
  end

  let(:test_class) { Test.new }

  describe 'type :price' do
    it 'properly parses' do
      expect(test_class.parse_price('123.45')).to eq 123.45
    end

    it 'properly dumps' do
      expect(test_class.dump_price(BigDecimal('123.45'))).to eq '123.45'
    end
  end

  describe 'type :qty' do
    it 'properly parses' do
      expect(test_class.parse_qty('123')).to eq 123
    end

    it 'properly dumps' do
      expect(test_class.dump_qty(123)).to eq '123'
    end
  end

  describe 'type :timestamp' do
    it 'properly parses' do
      expect(test_class.parse_timestamp('20161129-11:22:33')).to eq Time.utc(2016, 11, 29, 11, 22, 33)
    end

    it 'properly dumps' do
      expect(test_class.dump_timestamp(Time.utc(2016, 11, 29, 11, 22, 33))).to eq '20161129-11:22:33'
    end
  end

  describe 'type :local_market_date' do
    it 'properly parses' do
      expect(test_class.parse_local_market_date('20161129')).to eq Time.utc(2016, 11, 29)
    end

    it 'properly dumps' do
      expect(test_class.dump_local_market_date(Time.utc(2016, 11, 29))).to eq '20161129'
    end
  end
end
