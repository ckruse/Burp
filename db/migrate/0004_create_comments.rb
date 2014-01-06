# -*- coding: utf-8 -*-

class CreateComments < ActiveRecord::Migration
  def change
    create_table(:comments) do |t|
      ## Database authenticatable
      t.boolean :visible, null: false

      t.string :author, null: false
      t.string :email
      t.string :url

      t.json :attrs, null: false, default: "{}"

      t.text :content, null: false

      t.timestamps
    end

    add_reference :comments, :post, index: true, null: false
  end
end

# eof
