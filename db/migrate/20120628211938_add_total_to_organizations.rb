class AddTotalToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :totaljobs, :integer, :default => 0
    add_column :organizations, :totaladmins, :integer, :default =>1
    add_column :organizations, :totalschools, :integer, :default => 1
    Organization.all.each do |organization|
      organization.update_attribute(:totaljobs,organization.jobcount)
      organization.update_attribute(:totalschools,organization.schools.count)
      organization.update_attribute(:totaladmins,organization.admincount)
    end
  end
end
