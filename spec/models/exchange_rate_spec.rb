require 'spec_helper'

RSpec.describe ExchangeRate, type: :model do
  describe 'validations' do
    subject { ExchangeRate.new(period: Date.today, value: 1.1111) }

    it { is_expected.to validate_presence_of(:period) }
    it { is_expected.to validate_uniqueness_of(:period) }

    it { is_expected.to validate_presence_of(:value) }
    it do
      is_expected.to validate_numericality_of(:value)
        .is_greater_than_or_equal_to(0)
    end
  end

  describe '.current_value' do
    context 'when table is empty' do
      it 'returns nil when date value given' do
        expect(ExchangeRate.current_value('2017-01-11')).to be_nil
      end

      it 'returns nil when date value empty' do
        expect(ExchangeRate.current_value).to be_nil
      end
    end

    context 'when records exist' do
      before do
        ExchangeRate.create(period: Date.today, value: 1.1111)
        ExchangeRate.create(period: 2.days.ago, value: 1.2222)
        ExchangeRate.create(period: 4.days.ago, value: 1.4444)
        ExchangeRate.create(period: 5.days.ago, value: 1.5555)
      end

      it 'returns today\'s rate when date value empty' do
        expect(ExchangeRate.current_value).to eq(1.1111)
      end

      it 'returns rate from given date if available' do
        expect(ExchangeRate.current_value(2.days.ago)).to eq(1.2222)
      end

      it 'returns rate from previous date if current not available' do
        expect(ExchangeRate.current_value(3.days.ago)).to eq(1.4444)
      end

      it 'returns rate from current date if date is from future' do
        expect(ExchangeRate.current_value(5.days.since)).to eq(1.1111)
      end
    end
  end
end
