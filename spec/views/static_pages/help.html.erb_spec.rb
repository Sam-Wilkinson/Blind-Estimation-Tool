require 'rails_helper'

RSpec.describe 'static_pages/help', type: :view do
  before do
    render
  end

  it 'shows the title' do
    expect(rendered).to match(t('views.static_pages.help.title'))
  end
end
