require 'rails_helper'

RSpec.describe 'EstimationValues', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, isAdmin: true) }

  context 'when the user is not logged in' do
    it 'redirects to the log in page' do
      get estimation_values_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when the user is not website admin' do
    before do
      sign_in(user)
    end

    it 'redirects to the root page' do
      get estimation_values_path
      expect(response).to redirect_to root_path
    end

    it 'flashes an error message' do
      get estimation_values_path
      follow_redirect!
      expect(response.body).to include(I18n.t('views.estimations.values.flash_messages.access.denied'))
    end
  end

  context 'when admin is logged in' do
    before do
      sign_in(admin)
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
          post '/estimation_values', params: { estimation_value: { value: 20, placement: 23 } }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(assigns(:estimation_value))
          follow_redirect!

          expect(response).to render_template(:index)
          expect(response.body).to include(I18n.t('views.estimations.values.flash_messages.create.success'))
        end
      end

      context 'when the estimation_value is invalid' do
        it 'redirects to the estimation_value index page and flashes an error message' do
          post '/estimation_values', params: { estimation_value: { value: nil, placement: nil } }

          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(assigns(:estimation_value))
          follow_redirect!

          expect(response).to render_template(:index)
          expect(response.body).to include(I18n.t('views.estimations.values.flash_messages.create.failure'))
        end
      end
    end

    describe 'delete estimation_value' do
      let(:estimation_value) { create(:estimation_value) }

      it 'deletes the estimation_value' do
        delete estimation_value_path(estimation_value)
        expect(EstimationValue.all).not_to include(estimation_value)
      end

      it 'redirects to estimation index' do
        delete estimation_value_path(estimation_value)
        expect(response).to redirect_to(estimation_values_path)
      end

      it 'flashes a success message' do
        delete estimation_value_path(estimation_value)
        follow_redirect!
        expect(response.body).to match(I18n.t('views.estimations.values.flash_messages.delete.success'))
      end
    end

    describe 'update estimation_value' do
      let(:estimation_value) { create(:estimation_value) }

      it 'updates estimation of the estimation_value' do
        patch estimation_value_path(estimation_value,
                                    estimation_value: { value: estimation_value.value, placement: (estimation_value.placement + 1) })
        expect(EstimationValue.find(estimation_value.id).placement).not_to eq(estimation_value.placement)
        expect(EstimationValue.find(estimation_value.id).placement).to eq(estimation_value.placement + 1)
      end

      it 'updates the value of the estimation_value' do
        patch estimation_value_path(estimation_value,
                                    estimation_value: { value: (estimation_value.value + 1), placement: estimation_value.placement })
        expect(EstimationValue.find(estimation_value.id).value).not_to eq(estimation_value.value)
        expect(EstimationValue.find(estimation_value.id).value).to eq(estimation_value.value + 1)
      end

      it 'redirects to the index page' do
        patch estimation_value_path(estimation_value, estimation_value: { value: estimation_value.value, placement: estimation_value.placement })
        expect(response).to redirect_to estimation_values_path
      end

      it 'flashes a success message' do
        patch estimation_value_path(estimation_value, estimation_value: { value: estimation_value.value, placement: estimation_value.placement })
        follow_redirect!
        expect(response.body).to match(I18n.t('views.estimations.values.flash_messages.update.success'))
      end
    end
  end
end
