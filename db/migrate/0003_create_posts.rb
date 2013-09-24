# -*- coding: utf-8 -*-

class CreatePosts < ActiveRecord::Migration
  def change
    create_table(:posts) do |t|
      ## Database authenticatable
      t.string :slug, null: false
      t.string :guid, null: false
      t.boolean :visible, null: false

      t.integer :blog_id, null: false
      t.integer :author_id, null: false

      t.string :subject, null: false
      t.text :excerpt
      t.text :content, null: false
      t.string :format, null: false, default: 'html'

      t.json :attributes, null: false, default: '{}'

      t.timestamp :published, null: false

      t.timestamps
    end


    add_index :posts, :guid, :unique => true
    add_index :posts, :slug, :unique => true

    add_index :posts, :blog_id

    reversible do |dir|
      dir.up do
        execute "ALTER TABLE posts ADD CONSTRAINT blog_id_fk FOREIGN KEY (blog_id) REFERENCES blogs (id) ON DELETE CASCADE ON UPDATE CASCADE;"
        execute "ALTER TABLE posts ADD CONSTRAINT author_id_fk FOREIGN KEY (author_id) REFERENCES authors (id) ON DELETE CASCADE ON UPDATE CASCADE;"
      end

      dir.down do
        execute "ALTER TABLE posts DROP CONSTRAINT blog_id_fk"
        execute "ALTER TABLE posts DROP CONSTRAINT author_id_fk"
      end
    end
  end
end

# eof
