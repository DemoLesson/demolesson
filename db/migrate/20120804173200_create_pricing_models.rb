class CreatePricingModels < ActiveRecord::Migration
  def change
    create_table :pricing_models do |t|
      t.string :region
      t.string :country
      t.string :cycle_length
      t.decimal :price_per_cycle, :precision => 30, :scale => 2

      t.timestamps
    end
  end
end
