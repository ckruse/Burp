# -*- coding: utf-8 -*-

class Post < ActiveRecord::Base
  belongs_to :author
  belongs_to :blog

  has_many :tags
  has_many :comments
end

# eof
