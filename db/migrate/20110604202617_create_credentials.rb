class CreateCredentials < ActiveRecord::Migration
  def self.up
    create_table :credentials do |t|
      t.string :type
      t.string :name
      t.string :issuer

      t.timestamps
    end

    create_table :credentials_teachers do |t|
      t.integer :teacher_id
      t.integer :credential_id

      t.timestamps
    end

    create_table :credentials_jobs do |t|
      t.integer :job_id
      t.integer :credential_id

      t.timestamps
    end
  end

  def self.down
    drop_table :credentials
  end
end
