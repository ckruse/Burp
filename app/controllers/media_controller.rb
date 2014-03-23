# -*- coding: utf-8 -*-

class MediaController < ApplicationController
  def show
    fname = params[:slug]
    fname << '.' + params[:format] unless params[:format].blank?

    @medium = Medium.where(url: fname).first
    send_file(@medium.full_path, disposition: 'inline', type: @medium.media_type)
  end
end

# eof
