# -*- coding: utf-8 -*-

class Admin::BlogsController < ApplicationController
  before_filter :authenticate_author!
  layout 'admin'

  def blog_params
    if current_author.admin?
      params.require(:blog).permit(:name, :description, :keywords, :image_url, :lang, :url, :host, :author_id)
    else
      params.require(:blog).permit(:name, :description, :keywords, :image_url, :lang)
    end
  end

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
    unless current_author.admin?
      render nothing: true, status: 403
      return
    end

    @blog = Blog.new
  end

  def edit
    @blog = Blog.find params[:id] if @blog.blank?
  end

  def create
    unless current_author.admin?
      render nothing: true, status: 403
      return
    end

    @blog = Blog.new(blog_params)

    params[:attrs].each do |attr, val|
      @blog.attrs[attr] = val
    end

    if @blog.save
      redirect_to edit_admin_blog_url(@blog), notice: I18n.t('admin.blogs.created')
    else
      render :new
    end
  end

  def update
    @blog = Blog.find params[:id] if @blog.blank?
    @blog.attributes = blog_params

    changed = false
    params[:attrs].each do |attr, val|
      @blog.attrs[attr] = val
      changed = true
    end

    @blog.changed_attributes['attrs'] = true if changed

    if @blog.save
      redirect_to edit_admin_blog_url(@blog), notice: I18n.t('admin.blogs.updated')
    else
      render :edit
    end
  end

  def destroy
    unless current_author.admin?
      render nothing: true, status: 403
      return
    end


    @blog = Blog.find params[:id] if @blog.blank?
    @blog.destroy

    redirect_to admin_blogs_url, notice: I18n.t('admin.blogs.destroyed')
  end

end

# eof
