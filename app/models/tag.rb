# -*- coding: utf-8 -*-

class Tag < ActiveRecord::Base
  belongs_to :post

  def to_param
    tag_name.parameterize
  end
end

# eof
