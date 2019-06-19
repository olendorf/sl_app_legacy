# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :avatar_key,         null: false
      t.string :avatar_name,        null: false
      t.string :encrypted_password, null: false, default: ""
      
      t.integer :role,                           default: 0
      
      t.integer :object_weight,                  default: 0
      t.integer :account_level,                  default: 0
      t.datetime :expiration_date

      ## Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip


      t.timestamps null: false
    end

    add_index :users, :avatar_key,                unique: true
    add_index :users, :avatar_name,               unique: true
    add_index :users, :account_level
  end
end
