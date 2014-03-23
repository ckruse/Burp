# -*- coding: utf-8 -*-

class PostsController < ApplicationController
  def index
    if @blog
      @posts = Post.includes(:comments, :author, :tags, :blog).order(published_at: :desc, created_at: :desc, subject: :asc).limit(10).where(blog_id: @blog.id)
    else
      @posts = Post.includes(:comments, :author, :tags, :blog).order(published_at: :desc, created_at: :desc, subject: :asc).limit(10)
    end

    respond_to do |format|
      format.html
      format.rss
      format.atom
      format.json { render @posts }
    end

  end

  def show
    id = id_from_params

    if @blog
      @post = Post.includes(:comments, :author, :tags).where(slug: id, blog_id: @blog.id).order("comments.created_at, tags.tag_name").first!
    else
      @post = Post.includes(:comments, :author, :tags).where(slug: id).order("comments.created_at, tags.tag_name").first!
    end

    @validator_field, @validator_value = CommentsController.fields
    cookies[:validator_field] = @validator_field
    cookies[:validator_value] = @validator_value

    @comment = Comment.new

    author, email, url = cookies[:author], cookies[:email], cookies[:url]
    @comment.author ||= author
    @comment.email ||= email
    @comment.url ||= url
  end
end

# eof
