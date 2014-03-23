# -*- coding: utf-8 -*-

class Admin::MediaController < ApplicationController
  before_filter :authenticate_author!
  layout 'admin'

  def medium_params
    params.require(:medium).permit(:name)
  end

  def index
    if @blog
      @media = Medium.
        where(blog_id: @blog.id).
        includes(:blog).
        paginate(page: params[:page], per_page: 10).
        order(:name)
    else
      @media = Medium.
        includes(:blog).
        paginate(page: params[:page], per_page: 10).
        order(:name)
    end

  end

  def new
    raise ActiveRecord::RecordNotFound if @blog.blank?
    @medium = Medium.new
  end

  def create
    file = params[:medium][:file]
    params[:medium].delete :file

    @medium = Medium.new(medium_params)

    uuid = UUID.new
    exists = true
    fd = nil

    while exists
      u = uuid.generate
      @medium.path = u

      begin
        fd = File.open(@medium.full_path, File::WRONLY|File::EXCL|File::CREAT)
        fd.close
        exists = false
      rescue
        fd = nil
      end
    end

    if fd
      fd = File.open(@medium.full_path, "w:binary")
      fd.write(file.read)

      @medium.media_type = file.content_type
      fname = file.original_filename.gsub(/.*[\\\/]/, '')
      suffix = fname.gsub(/.*\,[a-z]{2,}/, '')
      @medium.url = fname.parameterize + '.' + suffix
      @medium.blog_id = @blog.id

      fd.close
    end


    if @medium.save
      redirect_to admin_media_url, notice: I18n.t('admin.media_controller.created')
    else
      File.unlink(@medium.full_path) if fd and File.exists?(@medium.full_path)
      render :new
    end
  end

  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy

    redirect_to admin_media_url, notice: I18n.t('admin.media_controller.deleted')
  end
end

# eof
