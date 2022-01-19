require 'rails_helper'

RSpec.describe 'EstimationValues', type: :request do
  let(:user) { create(:user) }

  context 'when the user is not logged in' do
    it 'redirects to the log in page' do
      get estimation_values_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when user is logged in' do
    before do
      sign_in(user)
    end

    describe 'GET /index' do
      it 'renders the index template' do
        get estimation_values_path
        expect(response).to render_template('estimation_values/index')
      end

      it 'displays estimation values' do
        @estimation_values = [create(:estimation_value, placement: 1), create(:estimation_value, placement: 2)]
        get estimation_values_path
        expect(response.body).to match('td')
      end
    end

    describe 'POST estimation_value' do
      context 'when the estimation_value is valid' do
        it 'creates an estimation_value and redirects to the estimation_value index page' do
          post '/estimation_values', params: { value: 20, placement: 23 }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(assigns(:estimation_value))
          follow_redirect!

          expect(response).to render_template(:index)
          expect(response.body).to include(I18n.t('views.estimations.values.flash_messages.success'))
        end
      end

      context 'when the estimation_value is invalid' do
        it 'redirects to the estimation_value index page and flashes an error message' do
          post '/estimation_values', params: { value: nil, placement: nil }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(assigns(:estimation_value))
          follow_redirect!

          expect(response).to render_template(:index)
          expect(response.body).to include(I18n.t('views.estimations.values.flash_messages.failure'))
        end
      end
    end
  end
end
