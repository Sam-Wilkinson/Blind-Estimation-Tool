require 'rails_helper'

RSpec.describe 'RoomUsers', type: :request do
  describe 'kick user from room' do
    let(:user) { create(:user) }
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
end
