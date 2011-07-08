class AlphaSignupType < ActiveRecord::Migration
  def self.up
    add_column :alphas, :type, :integer
  end

  def self.down
    remove_column :alphas, :type
  end
end
