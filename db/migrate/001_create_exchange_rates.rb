# Create table for storing USD to EUR exchange rates
class CreateExchangeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :exchange_rates do |t|
      t.date :period, null: false, index: { unique: true }
      t.decimal :value, precision: 6, scale: 4, null: false

      t.timestamps
    end
  end
end
