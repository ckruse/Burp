# -*- coding: utf-8 -*-

class CreateBlogs < ActiveRecord::Migration
  def change
    create_table(:blogs) do |t|
      ## Database authenticatable
      t.string :name,               null: false
      t.string :description,        null: false
      t.string :keywords,           null: false
      t.string :url,                null: false
      t.string :image_url,          null: false
      t.string :lang,               null: false
      t.string :host,               null: false
      t.json :attrs,                null: false, default: '{}'

      t.timestamps
    end

    add_reference :blogs, :author, index: true, null: false
    add_index :blogs, :host, :unique => true
  end
end

# eof
