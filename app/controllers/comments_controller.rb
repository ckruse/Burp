# -*- coding: utf-8 -*-

class CommentsController < ApplicationController
  FIELD_NAMES  = %w(
    comment_validator lulu_comment dont_spam_me spam_just_sucks
    spammers_are_the_scum_of_the_internet fuck_off_spammers
    little_spammer_pig just_another_field_name
  )

  def self.fields
    chars = ('A' .. 'Z').to_a + ('a' .. 'z').to_a + ('0'..'9').to_a +
      '!@#$Z%^&*()_+-=[]{};:\'",<.>"'.split(//)

    validator_field = CommentsController::FIELD_NAMES[rand CommentsController::FIELD_NAMES.length]
    validator_value = ''

    32.times do
      validator_value << chars[rand chars.length]
    end

    return validator_field, validator_value
  end

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

    @validator_field, @validator_value = CommentsController.fields
    cookies[:validator_field] = @validator_field
    cookies[:validator_value] = @validator_value

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

    if cookies[:validator_field].blank? || cookies[:validator_value].blank? ||
        params[cookies[:validator_field].to_sym].blank? ||
        params[cookies[:validator_field].to_sym] != cookies[:validator_value]
      head status: 500
      return
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

      redirect_to post_url(@post), notice: t('comments.successfully saved')
    else
      render :new
    end

  end
end

# eof
