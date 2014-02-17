# -*- coding: utf-8 -*-

class Comment < ActiveRecord::Base
  belongs_to :post

  validates :author, presence: true, length: {in: 3..255}
  validates :content, presence: true, length: {minimum: 3}
  validates :url, length: {in: 0..255}
  validates :email, length: {in: 0..255}

  scope :visibles, ->{ where(visible: true) }

end

# eof
