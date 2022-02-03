require 'rails_helper'

RSpec.describe 'user_stories/show', type: :view do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:user_story) { create(:user_story, room: room) }

  before do
    allow(view).to receive(:current_user).and_return(user)
    assign(:user_story, user_story)
    room.users << user
  end

  it 'displays the user_story title' do
    render
    expect(rendered).to match(user_story.title)
  end

  it 'can display the user story description' do
    render
    expect(rendered).to match(user_story.title)
  end
end
