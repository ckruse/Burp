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

  def new
    raise ActiveRecord::RecordNotFound if @blog.blank?
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    @post.slug = @post.slug.gsub(/.*\//, '')
    raise ActiveRecord::RecordNotFound if @blog and @post.blog_id != @blog.id
  end

  def post_params
    params.require(:post).permit(:subject, :slug, :visible, :excerpt, :content)
  end

  def create
    @post = Post.new(post_params)

    tags = params[:tags].split(/\s+,\s+/)
    my_tags = []

    tags.each do |t|
      tag = Tag.new(tag_name: t)
      my_tags << tag
    end

    @post.tags = my_tags
    @post.blog_id = @blog.id
    @post.guid = post_url(@post)
    @post.author_id = current_author.id
    @post.published_at = DateTime.now
    @post.slug = @post.published_at.strftime('%Y/%b/').downcase + @post.slug

    saved = false
    Post.transaction do
      if @post.save
        @post.tags.each do |t|
          t.post_id = @post.id
          raise ActiveRecord::Rollback unless t.save
        end
        saved = true
      end
    end

    if saved
      redirect_to edit_admin_post_url(@post), notice: I18n.t('admin.posts.created')
    else
      @post.slug = @post.slug.gsub(/.*\//, '')
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.attributes = post_params

    tags = params[:tags].split(/\s*,\s*/)
    my_tags = []

    tags.each do |t|
      tag = Tag.new(post_id: @post.id, tag_name: t)
      my_tags << tag
    end

    @post.slug = @post.published_at.strftime('%Y/%b/').downcase + @post.slug

    saved = false
    Post.transaction do
      if @post.save
        @post.tags.clear
        my_tags.each do |t|
          t.post_id = @post.id
          raise ActiveRecord::Rollback unless t.save
        end

        saved = true
      end
    end

    if saved
      redirect_to edit_admin_post_url(@post), notice: I18n.t('admin.posts.updated')
    else
      @post.slug = @post.slug.gsub(/.*\//, '')
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to admin_posts_url, notice: I18n.t('admin.posts.deleted')
  end
end

# eof
