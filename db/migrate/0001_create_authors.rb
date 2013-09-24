# -*- coding: utf-8 -*-

class CreateAuthors < ActiveRecord::Migration
  def change
    create_table(:authors) do |t|
      ## Database authenticatable
      t.string :username,           null: false
      t.string :name,               null: false
      t.string :email,              null: false
      t.string :url
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps
    end

    add_index :authors, :username,             :unique => true
    add_index :authors, :email,                :unique => true
    add_index :authors, :reset_password_token, :unique => true
  end
end

# eof
