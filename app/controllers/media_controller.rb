# -*- coding: utf-8 -*-

class MediaController < ApplicationController
  def show
    @medium = Medium.where(url: params[:slug]).first
    send_file(@medium.full_path, disposition: 'inline', type: @medium.media_type)
  end
end

# eof
