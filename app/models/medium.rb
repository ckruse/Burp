# -*- coding: utf-8 -*-

class Medium < ActiveRecord::Base
  belongs_to :blog

  validates_presence_of :path, :url
  validates :url, uniqueness: { scope: :blog_id }

  def full_path
    Rails.root + 'public/media' + self.path
  end

  def content
    fd = File.open(Rails.application.config.storage.to_s + "/attachments/" + path, "r:binary")
    cnt = fd.read
    fd.close

    cnt
  end

  after_destroy do
    begin
      File.unlink(full_path)
    rescue
    end
  end

end

# eof
