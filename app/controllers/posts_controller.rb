class PostsController < ApplicationController
  def index
    if @blog
      @posts = Post.includes(:comments, :author, :tags, :blog).order(published_at: :desc, created_at: :desc, subject: :asc).limit(10).where(blog_id: @blog.id)
    else
      @posts = Post.includes(:comments, :author, :tags, :blog).order(published_at: :desc, created_at: :desc, subject: :asc).limit(10)
    end
  end

  def show
    id = id_from_params

    if @blog
      @post = Post.includes(:comments, :author, :tags).where(slug: id, blog_id: @blog.id).order("comments.created_at, tags.tag_name").first!
    else
      @post = Post.includes(:comments, :author, :tags).where(slug: id).order("comments.created_at, tags.tag_name").first!
    end

    @comment = Comment.new

    if cookies[:burp]
      author, email, url = cookies[:burp].split '----'

      @comment.author ||= author
      @comment.email  ||= email
      @comment.url    ||= url
    end
  end
end
