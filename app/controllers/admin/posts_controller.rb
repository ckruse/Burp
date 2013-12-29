# -*- coding: utf-8 -*-

class Admin::PostsController < ApplicationController
  before_filter :authenticate_author!
  layout 'admin'

  def index
    if @blog
      @posts = Post.
        where(blog_id: @blog.id).
        includes(:blog).
        paginate(page: params[:page], per_page: 10).
        order(created_at: :desc)
    else
      @posts = Post.
        includes(:blog).
        paginate(page: params[:page], per_page: 10).
        order(created_at: :desc)
    end

  end

  def show
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end

# eof
