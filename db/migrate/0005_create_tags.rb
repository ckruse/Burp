# -*- coding: utf-8 -*-

class CreateTags < ActiveRecord::Migration
  def change
    create_table(:tags) do |t|
      ## Database authenticatable
      t.integer :post_id, null: false
      t.string :tag_name, null: false
    end

    add_index :tags, :post_id

    reversible do |dir|
      dir.up { execute "ALTER TABLE tags ADD CONSTRAINT post_id_fk FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE ON UPDATE CASCADE;" }
      dir.down { execute "ALTER TABLE tags DROP CONSTRAINT post_id_fk" }
    end
  end
end

# eof
