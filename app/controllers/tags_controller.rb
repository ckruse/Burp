# -*- coding: utf-8 -*-

class TagsController < ApplicationController
  def index
    if params[:tag]
      redirect_to tag_path(params[:tag])
      return
    end

    @tags = Tag.select('LOWER(tag_name) AS tag_name, COUNT(*) AS cnt').joins('INNER JOIN posts ON tags.post_id = posts.id').group('LOWER(tag_name)').order('cnt DESC')
    @tags = @tags.where('blog_id = ?', @blog.id) if @blog

    respond_to do |format|
      format.html do
        @max_count = 0
        @min_count = -1

        @tags.each do |t|
          @max_count = t.cnt if t.cnt > @max_count
          @min_count = t.cnt if t.cnt < @min_count or @min_count == -1
        end

      end
      format.json { render json: @tags }
    end
  end

  def show
    @tag = params[:tag]
    @posts = Post.where('id IN (SELECT post_id FROM tags WHERE LOWER(tag_name) = ?)', @tag).order('updated_at DESC, created_at DESC')
    @posts = @posts.where('blog_id = ?', @blog.id) if @blog
  end

end

# eof
