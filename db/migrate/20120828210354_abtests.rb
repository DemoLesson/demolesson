class Abtests < ActiveRecord::Migration
  	def up
		create_table :abtests do |t|
			t.column :slug, :string
			t.column :inc, :integer, :null => false, :default => 0
			t.column :maxinc, :integer, :null => false, :default => 1
		end
	end

	def down
		drop_table :abtests
	end
end
