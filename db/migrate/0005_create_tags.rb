# -*- coding: utf-8 -*-

class CreateTags < ActiveRecord::Migration
  def change
    create_table(:tags) do |t|
      ## Database authenticatable
      t.string :tag_name, null: false
    end

    add_reference :tags, :post, null: false, index: true
  end
end

# eof
