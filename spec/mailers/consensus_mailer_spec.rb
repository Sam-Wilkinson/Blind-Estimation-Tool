require 'rails_helper'

RSpec.describe ConsensusMailer, type: :mailer do
  describe 'consensus_failed_email' do
    it 'sends an email user story room admin' do
      user_story = create(:user_story)
      user_story.room.admin.update(email: 'test@testemail.com')
      mail = described_class.with(user_story: user_story).consensus_failed_email.deliver_now
      expect(mail.to).to eq(['test@testemail.com'])
    end

    it 'sets the subject' do
      mail = described_class.with(user_story: build(:user_story)).consensus_failed_email.deliver_now
      expect(mail.subject).to eq(I18n.t('views.mailer.consensus_failed.subject'))
    end
  end
end
