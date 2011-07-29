class CreateCredentialsTable < ActiveRecord::Migration
  def self.up
    create_table :credentials do |t|
      t.string :type, :null => false
      t.string :name, :null => false
      t.string :issuer

      t.timestamps
    end

    create_table :credentials_teachers, :id => false do |t|
      t.integer :teacher_id, :null => false
      t.integer :credential_id, :null => false

      t.timestamps
    end

    create_table :credentials_jobs, :id => false do |t|
      t.integer :job_id, :null => false
      t.integer :credential_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :credentials
  end
end
