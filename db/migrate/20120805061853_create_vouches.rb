class CreateVouches < ActiveRecord::Migration
  def change
    create_table :vouches do |t|
      t.integer :voucher_id
      t.integer :vouchee_id

      t.timestamps
    end
  end
end
