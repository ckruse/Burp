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

    reversible do |dir|
      dir.up { execute "ALTER TABLE blogs ADD COLUMN author_id INTEGER NOT NULL REFERENCES authors(id) ON DELETE CASCADE ON UPDATE CASCADE" }
      dir.down { execute "ALTER TABLE blogs DROP COLUMN author_id" }
    end

    add_index :blogs, :host, :unique => true
    add_index :blogs, :author_id
  end
end

# eof
