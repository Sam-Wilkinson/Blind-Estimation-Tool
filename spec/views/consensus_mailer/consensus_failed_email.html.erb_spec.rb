require 'rails_helper'

RSpec.describe 'consensus_mailer/consensus_failed_email', type: :view do
  let(:user_story) { create(:user_story) }

  before do
    assign(:user_story, user_story)
  end

  it 'displays the user story title' do
    user_story.update(title: 'hello world')
    render
    expect(rendered).to match('hello world')
  end

  it 'displays the user stort description' do
    user_story.update(description: 'worldly desciption of events')
    render
    expect(rendered).to match('worldly desciption of events')
  end

  it 'displays the no user story description' do
    user_story.update(description: '')
    render
    expect(rendered).to match(t('views.mailer.consensus_failed.no_available_description'))
  end

  it 'displays the estimation values of the users' do
    estimation_value = create(:estimation_value, value: '22')
    user_story.estimations << create(:estimation, user_story: user_story, estimation_value: estimation_value, user: user_story.room.admin)
    render
    expect(rendered).to match('22')
  end
end
