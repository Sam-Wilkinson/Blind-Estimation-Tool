class ConsensusMailer < ApplicationMailer
  def consensus_failed_email
    @user_story = params[:user_story]

    mail(to: @user_story.room.admin.email, subject: t('views.mailer.consensus_failed.subject'))
  end
end
