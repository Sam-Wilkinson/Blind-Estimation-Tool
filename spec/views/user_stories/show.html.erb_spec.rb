require 'rails_helper'

RSpec.describe 'user_stories/show', type: :view do
  let(:user) { create(:user) }
  let(:admin) { create(:user) }
  let(:room) { create(:room, admin: admin) }
  let(:user_story) { create(:user_story, room: room) }

  before do
    assign(:user_story, user_story)
    room.users << user
  end

  it 'displays the user_story title' do
    allow(view).to receive(:current_user).and_return(user)
    render
    expect(rendered).to match(user_story.title)
  end

  it 'can display the user story description' do
    allow(view).to receive(:current_user).and_return(user)
    render
    expect(rendered).to match(user_story.title)
  end

  context 'when user is room admin' do
    it 'displays the update user story' do
      allow(view).to receive(:current_user).and_return(admin)
      render
      expect(rendered).to match(t('views.user_stories.show.buttons.update'))
    end
  end
end
