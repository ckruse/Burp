# -*- coding: utf-8 -*-

class Admin::AdminController < ApplicationController
  before_filter :authenticate_author!
  layout 'admin'

  def dashboard
    if @blog
      @comments = Comment.
        joins('INNER JOIN posts ON posts.id = post_id').
        where('posts.blog_id = ?', @blog.id).
        limit(10).
        order(created_at: :desc)

      @entries = Post.
        where(blog_id: @blog.id).
        limit(10).
        order(:published_at, :created_at, :subject)

    else
      @comments = Comment.
        limit(10).
        order(:created_at)

      @entries = Post.
        limit(10).
        order(:published_at, :created_at, :subject)
    end
  end
end

# eof
