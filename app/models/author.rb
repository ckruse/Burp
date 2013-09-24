# -*- coding: utf-8 -*-

class Author < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :blogs
end

# eof
