# -*- coding: utf-8 -*-

class Post < ActiveRecord::Base
  belongs_to :author
  belongs_to :blog

  has_many :tags, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :subject, presence: true, length: {in: 3..250}
  validates :slug, presence: true, length: {in: 3..250}, format: { with: /[a-zA-Z0-9._-]/ }, uniqueness: true
  validates_presence_of :content
end

# eof
