# -*- coding: utf-8 -*-

class CommentsController < ApplicationController
  def new
    id = id_from_params

    if @blog
      @post = Post.includes(:comments, :author, :tags).
        where(slug: id, blog_id: @blog.id).
        order("comments.created_at, tags.tag_name").first!
    else
      @post = Post.includes(:comments, :author, :tags).
        where(slug: id).
        order("comments.created_at, tags.tag_name").first!
    end

    @comment = Comment.new unless @comment
  end

  def comment_params
    params.require(:comment).permit(:author,:email,:url,:content)
  end

  def create
    id = id_from_params

    if @blog
      @post = Post.includes(:comments, :author, :tags).
        where(slug: id, blog_id: @blog.id).
        order("comments.created_at, tags.tag_name").first!
    else
      @post = Post.includes(:comments, :author, :tags).
        where(slug: id).
        order("comments.created_at, tags.tag_name").first!
    end

    @comment = Comment.new(comment_params)
    @comment.post_id = @post.id
    @comment.visible = @post.blog.attrs['comments_moderated'] != 'yes'

    if params[:cookiesave] == 'yes'
      cookies[:author] = @comment.author
      cookies[:email] = @comment.email
      cookies[:url] = @comment.url
    end

    if params[:preview].blank? and @comment.save
      unless @post.blog.attrs['mail_notify'].blank?
        NewCommentMailer.
          new_comment(@post.blog.attrs['mail_notify'], @comment).deliver
      end

      redirect_to post_url(@post), notice: @post.blog.attrs['comments_moderated'] == 'yes' ? t('comments.successfully saved') : t('comments.successfully saved and moderated')
    else
      render :new
    end

  end
end

# eof
