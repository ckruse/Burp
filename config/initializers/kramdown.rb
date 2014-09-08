# -*- coding: utf-8 -*-

class Kramdown::Converter::CommentHtml < Kramdown::Converter::Html
  def convert_a(el, indent)
    el.attr['rel'] = 'nofollow'
    super
  end
end

# eof
