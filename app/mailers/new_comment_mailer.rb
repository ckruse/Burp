# -*- coding: utf-8 -*-

class NewCommentMailer < ActionMailer::Base
  default from: "burp@kennt-wayne.de"

  def new_comment(recipient, comment)
    @comment = comment
    mail(to: recipient, subject: I18n.t('new_comment_mailer.new_comment', author: @comment.author))
  end

  def send_alert(recipient, main_group, group, alert, reachability)
    @recipient    = recipient
    @main_group   = main_group
    @group        = group
    @alert        = alert
    @reachability = reachability

    mail(to: recipient, subject: sprintf("Erreichbarkeits-Warnung für Gruppe %s / %s: %.2f%%", main_group.name, group.name, reachability))
  end
end


# eof
