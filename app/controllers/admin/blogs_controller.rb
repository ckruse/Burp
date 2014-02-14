# -*- coding: utf-8 -*-

class Admin::BlogsController < ApplicationController
  before_filter :authenticate_author!
  layout 'admin'

  def index
    if @blog
      redirect_to edit_admin_blog_url(@blog)
      return
    end

    @blogs = Blog.
      paginate(page: params[:page], per_page: 10).
      order(:name)
  end

  def new
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
