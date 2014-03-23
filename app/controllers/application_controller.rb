class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  before_filter :load_blog, :load_burp_std

  private

  def load_blog
    Thread.current[:host] = request.host
    host = request.host
    @blog = Blog.find_by_host host

    if @blog
      I18n.locale = @blog.lang || I18n.default_locale
    end
  end

  def load_burp_std
    if @blog
      @last_four = Post.
        includes(:comments, :blog).
        where(blog_id: @blog.id).
        order(published_at: :desc, created_at: :desc).
        limit(4)

      @all_tags = Tag.
        select(:tag_name).
        joins("INNER JOIN posts ON posts.id = post_id").
        where("posts.blog_id = ?", @blog.id).
        group(:tag_name).
        order(:tag_name)

      @arc_months = Post.
        select("to_char(published_at, 'YYYY-mm') AS arc_mon").
        where(blog_id: @blog.id).
        group("to_char(published_at, 'YYYY-mm')").
        order("arc_mon desc")

    else
      @last_four = Post.
        includes(:comments, :blog).
        order(published_at: :desc, created_at: :desc).
        limit(4)

      @all_tags = Tag.
        select(:tag_name).
        group(:tag_name).
        order(:tag_name)

      @arc_months = Post.
        select("to_char(published_at, 'YYYY-mm') AS arc_mon").
        group("to_char(published_at, 'YYYY-mm')").
        order("arc_mon desc")
    end


  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

end
