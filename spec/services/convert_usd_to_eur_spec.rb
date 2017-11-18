require 'spec_helper'

RSpec.describe ConvertUsdToEur do
  describe '.call' do
    context 'when exchange rates table is empty' do
      it 'raises exception with no data given message' do
        expect { described_class.call(80) }.to raise_error(RuntimeError)
          .with_message(/No exchange rates available!/)
      end
    end

    context 'when exchange rates available' do
      before do
        ExchangeRate.create(period: '2016-12-20', value: 1.1111)
        ExchangeRate.create(period: '2016-12-17', value: 1.4444)
      end

      it 'returns converted value with most recent rate if day not specified' do
        expect(described_class.call(80)).to eq(72.0)
      end

      it 'returns converted value for specified day if given' do
        expect(described_class.call(80, '2016-12-20')).to eq(72.0)
      end

      it 'returns converted value by previous rate if current not available' do
        expect(described_class.call(80, '2016-12-18')).to eq(55.39)
      end
    end
  end
end
