require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let(:user) { create(:user) }

  context 'when not signed in' do
    it 'redirects to the login page' do
      get rooms_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when signed in' do
    before do
      sign_in(user)
    end

    describe 'GET /index' do
      before do
        get rooms_path
      end

      it { is_expected.to render_template('rooms/index') }
    end

    describe 'get /show' do
      let(:room) { create(:room) }

      context 'when the user is not part of the room' do
        it 'redirects to rooms index' do
          get room_path(room)
          expect(response).to redirect_to(rooms_path)
        end
      end

      context 'when the user is part of the room' do
        before do
          room.users << user
        end

        it 'renders the rooms/show template' do
          get room_path(room)
          expect(response).to render_template('rooms/show')
        end

        it 'displays the users' do
          users = create_list(:user, 3)
          room.users << [users]
          get room_path(room)

          users.each do |user|
            expect(response.body).to match(user.username)
          end
        end
      end
    end
  end
end
