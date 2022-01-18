require 'rails_helper'

RSpec.describe 'EstimationValues', type: :request do
  let(:user) { create(:user) }

  describe 'GET /index' do
    context 'when user is logged in' do
      before do
        sign_in(user)
      end

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

    context 'when user is not logged in' do
      it 'redirects to the log in page' do
        get estimation_values_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
