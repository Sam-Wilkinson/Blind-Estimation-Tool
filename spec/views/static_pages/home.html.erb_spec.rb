require 'rails_helper'

RSpec.describe 'static_pages/home', type: :view do

    before do
        render
    end

    it 'shows the title' do
        expect(rendered).to match(t('views.title'))
    end
    
end