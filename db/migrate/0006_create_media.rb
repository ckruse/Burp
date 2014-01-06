# -*- coding: utf-8 -*-

class CreateMedia < ActiveRecord::Migration
  def change
    create_table(:media) do |t|
      t.string :name, null: false
      t.string :media_type, null: false
      t.string :url, null: false
      t.string :path, null: false
    end

    add_index :media, :url
    add_reference :media, :blog, null: false
    add_index :media, [:blog_id, :url], unique: true
  end
end

# eof
