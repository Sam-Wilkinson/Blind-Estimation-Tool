require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user) }
  let(:room) { create(:room, admin: admin) }

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
      it 'renders the correct template' do
        get rooms_path
        expect(response).to render_template('rooms/index')
      end

      it 'filters and searches the rooms' do
        room = create(:room, name: 'room_name')
        get rooms_path, params: { search: 'something', filter: '' }
        expect(assigns(:rooms)).not_to include(room)
      end

      it 'provides categories to the view' do
        get rooms_path
        expect(assigns(:categories)).to be_truthy
      end
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

  describe 'create room' do
    before do
      sign_in(user)
    end

    context 'when the room is valid' do
      let(:valid_params) { { room: { name: 'room_name' } } }

      it 'creates a room' do
        post rooms_path, params: valid_params
        expect(Room.find_by(name: 'room_name')).not_to be_nil
      end

      it 'redirects to the room page' do
        post rooms_path, params: valid_params
        expect(response).to redirect_to room_path(1)
      end

      it 'flashes a success message' do
        post rooms_path, params: valid_params
        follow_redirect!
        expect(response.body).to include(I18n.t('views.rooms.actions.create_room.success'))
      end
    end

    context 'when the room is invalid' do
      let(:invalid_params) { { room: { name: nil } } }

      it 'does not create a room' do
        post rooms_path, params: invalid_params
        expect(Room.all).to be_empty
      end

      it 'redirects to the room index page' do
        post rooms_path, params: invalid_params
        expect(response).to redirect_to rooms_path
      end

      it 'flashes a failure message' do
        post rooms_path, params: invalid_params
        follow_redirect!
        expect(response.body).to include(I18n.t('views.rooms.actions.create_room.failure'))
      end
    end
  end

  describe 'destroy room' do
    context 'when user is not room admin' do
      before do
        sign_in(user)
      end

      it 'does not destroy the room' do
        delete room_path(room)
        expect(Room.all).to include(room)
      end

      context 'when the user is part of the room' do
        it 'redirects to the room page' do
          room.users << user
          delete room_path(room)
          expect(response).to redirect_to room_path(room)
        end
      end

      context 'when the user is not part of the room' do
        it 'redirects to the room index' do
          delete room_path(room)
          expect(response).to redirect_to rooms_path
        end
      end

      it 'flashes an error message' do
        delete room_path(room)
        follow_redirect!
        expect(response.body).to match(I18n.t('views.rooms.actions.delete_room.failure'))
      end
    end

    context 'when the user is room admin' do
      before do
        sign_in(admin)
      end

      it 'destroys the room' do
        delete room_path(room)
        expect(Room.all).not_to include(room)
      end

      it 'flashes a success message' do
        delete room_path(room)
        follow_redirect!
        expect(response.body).to match(I18n.t('views.rooms.actions.delete_room.success'))
      end

      it 'redirects to the room index' do
        delete room_path(room)
        expect(response).to redirect_to rooms_path
      end
    end
  end

  describe 'update room' do
    let(:param) { { room: { name: 'updated_name' } } }

    context 'when user is not room admin' do
      before do
        sign_in(user)
      end

      it 'does not update the room' do
        patch room_path(room, param)
        expect(Room.find_by(name: 'updated_name')).to be_nil
      end

      context 'when the user is part of the room' do
        it 'redirects to the room page' do
          room.users << user
          patch room_path(room, param)
          expect(response).to redirect_to room_path(room)
        end

        it 'flashes a warning message' do
          patch room_path(room, param)
          follow_redirect!
          expect(response.body).to match(I18n.t('views.rooms.actions.update_room.denied'))
        end
      end

      context 'when the user is not part of the room' do
        it 'redirects to the room index' do
          patch room_path(room, param)
          expect(response).to redirect_to rooms_path
        end
      end

      it 'flashes an error message' do
        patch room_path(room, param)
        follow_redirect!
        expect(response.body).to match(I18n.t('views.rooms.actions.update_room.denied'))
      end
    end

    context 'when the user is room admin' do
      before do
        sign_in(admin)
      end

      it 'updates the room' do
        patch room_path(room, param)
        expect(Room.find_by(name: 'updated_name')).not_to be_nil
      end

      it 'flashes a success message' do
        patch room_path(room, param)
        follow_redirect!
        expect(response.body).to match(I18n.t('views.rooms.actions.update_room.success'))
      end

      it 'redirects to the room index' do
        patch room_path(room, param)
        expect(response).to redirect_to room_path(room)
      end
    end
  end
end
