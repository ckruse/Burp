# -*- coding: utf-8 -*-

class CreateComments < ActiveRecord::Migration
  def change
    create_table(:comments) do |t|
      ## Database authenticatable
      t.integer :post_id, null: false
      t.boolean :visible, null: false

      t.string :author, null: false
      t.string :email
      t.string :url

      t.json :attrs, null: false, default: "{}"

      t.text :content, null: false

      t.timestamps
    end

    add_index :comments, :post_id

    reversible do |dir|
      dir.up { execute "ALTER TABLE comments ADD CONSTRAINT post_id_fk FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE ON UPDATE CASCADE;" }
      dir.down { execute "ALTER TABLE comments DROP CONSTRAINT post_id_fk" }
    end
  end
end

# eof
