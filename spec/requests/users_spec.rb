require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET /users/' do
    describe 'sign_in' do
      before do
        get new_user_session_path
      end

      it { is_expected.to render_template('devise/sessions/new') }
    end

    describe 'sign_up' do
      before do
        get new_user_registration_path
      end

      it { is_expected.to render_template('devise/registrations/new') }
    end

    describe 'edit' do
      before do
        sign_in(user)
        get edit_user_registration_path
      end

      it { is_expected.to render_template('devise/registrations/edit') }
    end
  end
end
