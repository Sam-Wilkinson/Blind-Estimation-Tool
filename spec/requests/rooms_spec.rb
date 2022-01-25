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

  describe 'join room' do
    let(:admin) { create(:user) }
    let(:room) { create(:room, admin: admin) }

    it 'doesnt add the admin to the rooms users' do
      sign_in(admin)
      post join_room_path(room)
      expect(room.users).not_to include(admin)
    end

    context 'when user is not admin' do
      before do
        sign_in(user)
      end

      it 'adds the user to the rooms users' do
        post join_room_path(room)
        expect(room.users.all).to include(user)
      end

      context 'when successful' do
        it 'flashes a success message' do
          post join_room_path(room)
          expect(response.body).to match(I18n.t('views.rooms.actions.join_room.success'))
        end

        it 'enters the room' do
          post join_room_path(room)
          expect(response).to render_template('rooms/show')
        end
      end

      context 'when user is already in the room' do
        before do
          room.users << user
        end

        it 'flashes a warning message' do
          post join_room_path(room)
          expect(response.body).to match(I18n.t('views.rooms.actions.join_room.middling'))
        end

        it 'enters the room' do
          post join_room_path(room)
          expect(response).to render_template('rooms/show')
        end
      end
    end
  end

  describe 'leave room' do
    let(:room) { create(:room) }

    before do
      sign_in(user)
    end

    context 'when user in room' do
      before do
        room.users << user
      end

      it 'removes user from the list of room users' do
        post leave_room_path(room)
        expect(room.users.all).not_to include(user)
      end

      it 'flashes a success message' do
        post leave_room_path(room)
        follow_redirect!
        expect(response.body).to match(I18n.t('views.rooms.actions.leave_room.success'))
      end
    end

    context 'when user isnt in room' do
      it 'flashes an error message' do
        post leave_room_path(room)
        follow_redirect!
        expect(response.body).to match(I18n.t('views.rooms.actions.leave_room.failure'))
      end
    end

    it 'redirects to the rooms index page' do
      post leave_room_path(room)
      expect(response).to redirect_to(rooms_path)
    end
  end

  describe 'create room' do
    before do
      sign_in(user)
    end

    context 'when the room is valid' do
      let(:valid_params) { { name: 'room_name' } }

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
      let(:invalid_params) { { name: nil } }

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
end
