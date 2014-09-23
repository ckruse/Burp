# -*- coding: utf-8 -*-

class AddPostingFormat < ActiveRecord::Migration
  def change
    change_table(:posts) do |t|
      t.string :posting_format, null: false, default: 'html'
    end
  end
end

# eof
