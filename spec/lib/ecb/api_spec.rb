require 'spec_helper'

RatesData = Struct.new(:success?, :rates, :error_message)

RSpec.describe Ecb::API do
  describe '.download_rates' do
    let(:download_rates) { described_class.download_rates }

    context 'when valid response given' do
      let(:response) do
        { status: 200,
          body: Ecb::ExampleResponses.successful_response_body,
          headers: { 'Content-Type' => 'text/csv' } }
      end

      before do
        stub_request(:get, 'http://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv')
          .with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'})
          .to_return(response)
      end

      it { expect(download_rates.success?).to eq(true) }
      it { expect(download_rates.rates.size).to eq(15) }
      it { expect(download_rates.rates).to include(['2017-11-17', '1.1795']) }
      it { expect(download_rates.error_message).to eq(nil) }
    end

    context 'when invalid response given' do
      let(:response) do
        { status: 200,
          body: Ecb::ExampleResponses.failed_response_body }
      end

      before do
        stub_request(:get, 'http://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv')
          .with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'})
          .to_return(response)
      end

      it { expect(download_rates.success?).to eq(false) }
      it { expect(download_rates.rates.size).to eq(0) }
      it do
        expect(download_rates.error_message)
          .to eq("There is no series in the cube to be exported")
      end
    end

    context 'when connection error occurs' do
      before do
        stub_request(:get, 'http://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv')
          .with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'})
          .to_raise(SocketError.new('You shall not pass!'))
      end

      it { expect(download_rates.success?).to eq(false) }
      it { expect(download_rates.rates.size).to eq(0) }
      it { expect(download_rates.error_message).to eq('You shall not pass!') }
    end
  end
end
