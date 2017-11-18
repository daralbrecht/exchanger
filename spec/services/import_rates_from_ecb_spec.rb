require 'spec_helper'

# Struct definition for testing results
RatesData = Struct.new(:success?, :rates, :error_message)

RSpec.describe ImportRatesFromEcb do
  describe '.call' do
    let(:call) { described_class.call }

    before do
      allow(Ecb::API).to receive(:download_rates).and_return(import_response)

      ExchangeRate.create(period: '2016-10-21', value: 1.1234)
      ExchangeRate.create(period: '2016-10-22', value: 1.2345)
    end

    context 'when API returns error' do
      let(:import_response) do
        RatesData.new(false, [], 'Some wicked error occured')
      end

      it { expect(call.success?).to eq(false) }
      it { expect(call.resolve_message).to eq(nil) }
      it { expect(call.error_message).to eq('Some wicked error occured') }
      it { expect { call }.not_to change(ExchangeRate, :count) }
    end

    context 'when API returns already existing data' do
      let(:import_response) do
        RatesData.new(true,
                      [['2016-10-21', '1.1234'], ['2016-10-22', '1.2345']])
      end

      it { expect(call.success?).to eq(true) }
      it { expect(call.resolve_message).to eq('No new rates for import') }
      it { expect(call.error_message).to eq(nil) }
      it { expect { call }.not_to change(ExchangeRate, :count) }
    end

    context 'when API returns new data' do
      let(:import_response) do
        RatesData.new(true,
                      [['2016-10-23', '1.3456'], ['2016-10-24', '1.4567']])
      end

      it { expect(call.success?).to eq(true) }
      it do
        expect(call.resolve_message).to eq('2 new rates imported successfully')
      end
      it { expect(call.error_message).to eq(nil) }
      it { expect { call }.to change(ExchangeRate, :count).by(2) }
    end

    context 'when API returns new and existing data' do
      let(:import_response) do
        RatesData.new(true,
                      [['2016-10-21', '1.1234'], ['2016-10-24', '1.4567']])
      end

      it { expect(call.success?).to eq(true) }
      it do
        expect(call.resolve_message).to eq('1 new rate imported successfully')
      end
      it { expect(call.error_message).to eq(nil) }
      it { expect { call }.to change(ExchangeRate, :count).by(1) }
    end
  end
end
