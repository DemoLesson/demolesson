class TeachForAmericaLock < ActiveRecord::Migration
  def up
    add_column :teachers, :tfa, :boolean
  end

  def down
  end
end
