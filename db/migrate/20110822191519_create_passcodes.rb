class CreatePasscodes < ActiveRecord::Migration
  def change
    create_table :passcodes do |t|
      t.string "code"
      t.timestamps
    end
  end
end
