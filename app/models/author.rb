# -*- coding: utf-8 -*-

class Author < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :blogs

  def active_for_authentication?
    load_blog

    return true if admin?
    return false if @blog.blank? and not admin?

    blogs.each do |b|
      return true if b.id == @blog.id
    end

    return false
  end

  private
  def load_blog
    @blog = Blog.find_by_host Thread.current[:host] if Thread.current[:host]
  end
end

# eof
