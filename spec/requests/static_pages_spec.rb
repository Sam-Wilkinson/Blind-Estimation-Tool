require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET /static_pages' do
    describe 'Get Home Page' do
      before do
        get home_path
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the home template' do
        expect(response).to render_template('home')
      end

      it 'has dynamic title' do
        expect(response.body).to match(Regexp.escape("#{I18n.t('views.static_pages.home.title')} | #{I18n.t('views.title')}"))
      end
    end

    describe 'Get About Page' do
      before { get about_path }

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the about template' do
        expect(response).to render_template('about')
      end

      it 'has dynamic title' do
        expect(response.body).to match(Regexp.escape("#{I18n.t('views.static_pages.about.title')} | #{I18n.t('views.title')}"))
      end
    end

    describe 'Get Help Page' do
      before { get help_path }

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the help template' do
        expect(response).to render_template('help')
      end

      it 'has dynamic title' do
        expect(response.body).to match(Regexp.escape("#{I18n.t('views.static_pages.help.title')} | #{I18n.t('views.title')}"))
      end
    end
  end
end
