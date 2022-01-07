require 'rails_helper'

RSpec.describe 'devise/sessions/new', type: :view do
  before do
    allow(view).to receive(:resource).and_return(create(:user))
    allow(view).to receive(:resource_name).and_return(:user)
    allow(view).to receive(:devise_mapping).and_return(Devise.mappings[:user])
    render
  end

  it 'displays the username input field' do
    expect(rendered).to match('username')
  end
end
