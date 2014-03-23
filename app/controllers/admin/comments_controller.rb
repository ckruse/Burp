# -*- coding: utf-8 -*-

class Admin::CommentsController < ApplicationController
  before_filter :authenticate_author!
  layout 'admin'

  def index
    if @blog
      @comments = Comment.
        joins('INNER JOIN posts ON posts.id = post_id').
        where('posts.blog_id = ?', @blog.id).
        includes(post: :blog).
        paginate(page: params[:page], per_page: @blog.attrs['comments_per_site'] || 50).
        order(created_at: :desc)
    else
      @comments = Comment.
        includes(post: :blog).
        paginate(page: params[:page], per_page: 50).
        order(created_at: :desc)
    end

  end

  def edit
    @comment = Comment.find params[:id]
    raise ActiveRecord::RecordNotFound if not @blog.blank? and @comment.post.blog_id != @blog.id
  end

  def update
    @comment = Comment.find params[:id]
    raise ActiveRecord::RecordNotFound if not @blog.blank? and @comment.post.blog_id != @blog.id

    respond_to do |format|
      if @comment.update_attributes(params.require(:comment).permit(:author, :email, :url, :content))
        format.html { redirect_to admin_comments_url, notice: t('admin.comments_controller.Comment has successfully been updated') }
        format.json { head :no_content, status: :ok }
      else
        format.html { render action: :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def batch_action
    raise ActiveRecord::RecordNotFound if params[:ids].blank?
    raise ActiveRecord::RecordNotFound if params[:show].nil? and params[:hide].nil? and params[:delete].nil?

    @comments = Comment.includes(:post).find(params[:ids])
    notice = ''

    if not params[:show].nil?
      @comments.each do |c|
        next if @blog and c.post.blog_id != @blog.id

        c.visible = true
        c.save
      end

      notice = 'Comments have successfully marked as visible'

    elsif not params[:hide].nil?
      @comments.each do |c|
        next if @blog and c.post.blog_id != @blog.id

        c.visible = false
        c.save
      end

      notice = 'Comments have successfully marked as invisible'
    elsif not params[:delete].nil?
      @comments.each do |c|
        next if @blog and c.post.blog_id != @blog.id

        c.destroy
      end

      notice = 'Comments have successfully been deleted'
    end

    redirect_to admin_comments_url, notice: t('admin.comments_controller.' + notice)
  end

  def visible
    @comment = Comment.find params[:id]
    raise ActiveRecord::RecordNotFound if not @blog.blank? and @comment.post.blog_id != @blog.id

    @comment.visible = true
    @comment.save

    respond_to do |format|
      format.html { redirect_to admin_comments_url, notice: t('admin.comments_controller.Comment has successfully been maked as visible') }
      format.json { head :no_content, status: :ok }
    end
  end

  def hidden
    @comment = Comment.find params[:id]
    raise ActiveRecord::RecordNotFound if not @blog.blank? and @comment.post.blog_id != @blog.id

    @comment.visible = false
    @comment.save

    respond_to do |format|
      format.html { redirect_to admin_comments_url, notice: t('admin.comments_controller.Comment has successfully been maked as invisible') }
      format.json { head :no_content, status: :ok }
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    raise ActiveRecord::RecordNotFound if not @blog.blank? and @comment.post.blog_id != @blog.id

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to admin_comments_url, notice: t('admin.comments_controller.Comment has successfully been deleted') }
      format.json { head :no_content, status: :ok }
    end

  end

end

# eof
