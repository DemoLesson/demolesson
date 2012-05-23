class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.integer :owned_by
      t.string :name
      t.integer :job_allowance, :default => 1
      t.integer :admin_allowance, :default => 1
      t.integer :school_allowance, :default => 1

      t.timestamps
    end

    User.all.each do |u|
      if !u.school.nil?
        o=Organization.create
        o.update_attribute(:owned_by, u.id)
      end
    end
  end
end
