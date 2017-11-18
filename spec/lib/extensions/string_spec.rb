require 'spec_helper'

RSpec.describe String do
  describe '#a_date?' do
    it { expect(''.a_date?).to eq(false) }
    it { expect('2017'.a_date?).to eq(false) }
    it { expect('today'.a_date?).to eq(false) }
    it { expect('2017-01-12'.a_date?).to eq(true) }
  end

  describe '#a_number?' do
    it { expect(''.a_number?).to eq(false) }
    it { expect('four'.a_number?).to eq(false) }
    it { expect('2much'.a_number?).to eq(false) }
    it { expect('2017'.a_number?).to eq(true) }
    it { expect('1.2222'.a_number?).to eq(true) }
  end
end
