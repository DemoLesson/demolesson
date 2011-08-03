class CreateLoginTokens < ActiveRecord::Migration
  def change
    create_table :login_tokens do |t|
      t.integer :user_id
      t.datetime :expires_at
      t.string :token_value, :limit => 36

      t.timestamps
    end
    add_index :login_tokens, :user_id, :unique => true
  end
end
