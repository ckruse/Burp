# -*- coding: utf-8 -*-

class ArchiveController < ApplicationController
  def years
    if params[:month_year]
      year, mon_num = params[:month_year].split('-', 2)
      redirect_to archive_month_path(mon_num, year)
      return
    end

    @years = Post.select('EXTRACT(YEAR FROM created_at) AS year, COUNT(*) AS cnt').group('EXTRACT(YEAR FROM created_at)').order('year DESC')
    @years = @years.where('blog_id = ?', @blog.id) if @blog

    respond_to do |format|
      format.html
      format.json { render json: @years }
    end
  end

  def months
    @year = params[:year]
    @months = Post.select("date_trunc('month', created_at) AS mon, COUNT(*) AS cnt").group("date_trunc('month', created_at)").order("date_trunc('month', created_at)")
    @months = @months.where("blog_id = ? AND extract(year from created_at) = ?", @blog.id, @year) if @blog

    respond_to do |format|
      format.html
      format.json { render json: @months }
    end
  end

  def posts
    mon = [nil, 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'].index(params[:month])

    @date_time = Date.civil(params[:year].to_i, mon, 1)

    @posts = Post.where("date_trunc('month', created_at) = ?", sprintf('%4d-%02d-01 00:00:00', params[:year], mon)).order('updated_at DESC, created_at DESC')
    @posts = @posts.where('blog_id = ?', @blog.id) if @blog
  end

end

# eof
