require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let(:user) { create(:user) }

  describe 'when signed in' do
    before do
      sign_in(user)
    end

    describe 'GET /index' do
      before do
        get rooms_path
      end

      it { is_expected.to render_template('rooms/index') }
    end
  end
end
