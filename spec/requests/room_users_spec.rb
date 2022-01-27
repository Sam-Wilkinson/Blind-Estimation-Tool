require 'rails_helper'

RSpec.describe 'RoomUsers', type: :request do
  let(:user) { create(:user) }

  describe 'kick user from room' do
    let(:admin) { create(:user) }
    let(:room) { create(:room, admin: admin) }
    let(:bad_user) { create(:user) }
    let(:params) { { user_id: bad_user.id } }

    it 'allows the admin to remove the user' do
      sign_in(admin)
      room.users << bad_user
      delete kick_user_room_path(room, params)
      follow_redirect!
      expect(flash[:notice]).to be_present
      expect(room.users.all).not_to include(bad_user)
    end

    it 'does not allow a user to remove another user' do
      sign_in(user)
      room.users << user
      room.users << bad_user
      delete kick_user_room_path(room, params)
      follow_redirect!
      expect(flash[:alert]).to be_present
      expect(room.users.all).to include(bad_user)
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

      it 'flashes a success message' do
        delete leave_room_path(room)
        follow_redirect!
        expect(flash[:notice]).to be_present
      end

      it 'removes access for the user' do
        delete leave_room_path(room)
        expect(room.users.all).not_to include(user)
      end
    end

    context 'when user isnt in room' do
      it 'flashes an error message' do
        delete leave_room_path(room)
        follow_redirect!
        expect(flash[:alert]).to be_present
      end
    end

    it 'redirects to the rooms index page' do
      delete leave_room_path(room)
      expect(response).to redirect_to(rooms_path)
    end
  end
end
