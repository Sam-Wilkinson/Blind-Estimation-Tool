# Preview all emails at http://localhost:3000/rails/mailers/consensus_mailer
class ConsensusMailerPreview < ActionMailer::Preview
  def consensus_failed_email
    # Set up a temporary order for the preview
    user_story = FactoryBot.create(:user_story)
    FactoryBot.create_list(:estimation, 3, user_story: user_story)
    user_story.reload
    ConsensusMailer.with(user_story: user_story).consensus_failed_email
  end
end
