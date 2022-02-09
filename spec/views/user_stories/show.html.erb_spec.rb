require 'rails_helper'

RSpec.describe 'user_stories/show', type: :view do
  let(:user) { create(:user) }
  let(:user_story) { create(:user_story) }

  before do
    assign(:user_story, user_story)
    assign(:estimation_values, EstimationValue.all)
    assign(:estimation, Estimation.new)
    assign(:estimations, Estimation.all)
  end

  context 'when user is not the room admin' do
    before do
      allow(view).to receive(:current_user).and_return(user)
    end

    it 'displays the user_story title' do
      user_story.update(title: 'This is the title of the user story: Cowabunga')
      render
      expect(rendered).to match('This is the title of the user story: Cowabunga')
    end

    it 'displays the user story description' do
      user_story.update(description: 'This is the description of a user story: Why does a cow have four legs, I must find out somehow, he doesnt know, she doesnt know, and neither does the cow, hey!')
      render
      expect(rendered).to match('This is the description of a user story: Why does a cow have four legs, I must find out somehow, he doesnt know, she doesnt know, and neither does the cow, hey!')
    end

    it 'displays the estimate button' do
      render
      expect(rendered).to match(t('views.user_stories.show.buttons.estimate'))
    end

    it 'displays the available estimation values' do
      estimation_value = create(:estimation_value, value: 112)
      assign(:estimation_values, [estimation_value])
      render
      expect(rendered).to match(112.to_s)
    end

    it 'displays the users who are required to estimate' do
      user.update(username: 'Samwise')
      user_story.room.users << user
      user_story.room.admin = create(:user, username: 'Gandalf')
      render
      expect(rendered).to match('Samwise')
      expect(rendered).to match('Gandalf')
    end

    it 'displays the user who has estimated in green' do
      create(:estimation, user: user, user_story: user_story)
      user_story.room.users << user
      render
      expect(rendered).to match('list-group-item-success')
    end

    it 'displays the user who has not estimated in red' do
      user_story.room.users << user
      render
      expect(rendered).to match('list-group-item-danger')
    end
  end

  context 'when the user has estimated' do
    it 'shows the estimated value of the user story' do
      allow(view).to receive(:current_user).and_return(user)
      estimation_value = create(:estimation_value, value: 667)
      estimation = create(:estimation, user: user, user_story: user_story, estimation_value: estimation_value)
      assign(:estimation, estimation)
      render
      expect(rendered).to match(667.to_s)
    end
  end

  context 'when user is room admin' do
    before do
      admin = create(:user)
      allow(view).to receive(:current_user).and_return(admin)
      user_story.room.admin = admin
    end

    it 'displays the update user story' do
      render
      expect(rendered).to match(t('views.user_stories.show.buttons.update'))
    end

    it 'displays the delete user story button' do
      render
      expect(rendered).to match(t('views.user_stories.show.buttons.delete'))
    end
  end

  context 'when the user story has been successfully estimated' do
    before do
      allow(view).to receive(:current_user).and_return(user)
    end

    it 'displays the user story in green' do
      user_story.estimation_value = create(:estimation_value)
      render
      expect(rendered).to match('bg-success')
    end
  end

  context 'when a consensus has not been reached' do
    it 'displays the restart button for the admin' do
      admin = create(:user)
      create(:estimation, user: admin)
      user_story.room.update(admin: admin)
      allow(view).to receive(:current_user).and_return(admin)
      user_story.update(estimation_value: nil)
      render
      expect(rendered).to match(t('views.user_stories.show.buttons.restart'))
    end
  end
end
