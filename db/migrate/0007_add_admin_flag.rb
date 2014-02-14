# -*- coding: utf-8 -*-

class AddAdminFlag < ActiveRecord::Migration
  def change
    change_table(:authors) do |t|
      t.boolean :admin, null: false, default: false
    end
  end
end

# eof
