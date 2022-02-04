require 'rails_helper'

RSpec.describe 'user_stories/show', type: :view do
  let(:user) { create(:user) }
  let(:admin) { create(:user) }
  let(:room) { create(:room, admin: admin) }
  let(:user_story) { create(:user_story, room: room) }
  let!(:estimation_value) { create(:estimation_value) }

  before do
    assign(:user_story, user_story)
    assign(:estimation_values, EstimationValue.order(placement: :asc))
    assign(:estimation, Estimation.new)
    room.users << user
  end

  context 'when user is not the room admin' do
    before do
      allow(view).to receive(:current_user).and_return(user)
      assign(:estimation, Estimation.new)
    end

    it 'displays the user_story title' do
      render
      expect(rendered).to match(user_story.title)
    end

    it 'can display the user story description' do
      render
      expect(rendered).to match(user_story.description)
    end

    it 'displays the estimate button' do
      render
      expect(rendered).to match(t('views.user_stories.show.buttons.estimate'))
    end

    it 'displays the available estimations' do
      render
      expect(rendered).to match(estimation_value.value.to_s)
    end
  end

  context 'when the user has estimated' do
    before do
      allow(view).to receive(:current_user).and_return(user)
      assign(:estimation, create(:estimation, user: user, user_story: user_story, estimation_value: estimation_value))
    end

    it 'shows the estimated value of the user story' do
      render
      expect(rendered).to match(estimation_value.value.to_s)
    end
  end

  context 'when user is room admin' do
    before do
      allow(view).to receive(:current_user).and_return(admin)
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
end
