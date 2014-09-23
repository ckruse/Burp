# -*- coding: utf-8 -*-

class Kramdown::Converter::CfHtml < Kramdown::Converter::Html
  def convert_codeblock(el, indent)
    ret = super(el, indent)

    ret.gsub!(/^<div>(.*)<\/div>/m, '\1')
    '<code><pre>' + ret + '</pre></code>'
  end
end

class Post < ActiveRecord::Base
  belongs_to :author
  belongs_to :blog

  has_many :tags, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :subject, presence: true, length: {in: 3..250}
  validates :slug, presence: true, length: {in: 3..250}, format: { with: /[a-zA-Z0-9._-]/ }, uniqueness: true
  validates_presence_of :content

  def to_html(fld = :content)
    return to_html_str(self.send(fld.to_sym))
  end

  def to_html_str(str)
    return str.html_safe if posting_format == 'html'
    return Kramdown::Document.new(str, coderay_wrap: nil, coderay_css: :class,
                                  coderay_line_numbers: nil, header_offset: 1).
      to_cf_html.html_safe
  end
end

# eof
