# Class for storing exchange rates from USD to EUR
class ExchangeRate < ActiveRecord::Base
  validates :period, :value, presence: true
  validates :period, uniqueness: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }

  def self.current_value(period = Date.today)
    where('period <= ?', period).order(period: :asc).last&.value
  end
end
