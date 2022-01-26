require 'rails_helper'

RSpec.describe 'rooms/show', type: :view do
  let(:admin) { create(:user) }
  let(:user) { create(:user) }
  let(:room) { create(:room, admin: admin) }

  before do
    assign(:room, room)
  end

  context 'when there are no users in the room' do
    before do
      allow(view).to receive(:current_user).and_return(admin)
    end

    it 'displays the call to action' do
      render
      expect(response).to match(t('views.rooms.show.other_users.call_to_action'))
    end

    it 'displays the close room button' do
      render
      expect(response).to match(t('views.rooms.show.buttons.destroy'))
    end
  end

  context 'when there are users' do
    before do
      room.users << user
    end

    context 'when the user is admin' do
      before do
        allow(view).to receive(:current_user).and_return(admin)
      end

      it 'displays the kick user button' do
        render
        expect(response).to match(t('views.rooms.show.table.titles.kick'))
        expect(response).to match(kick_user_room_path(room))
      end

      it 'does not display the leave room button' do
        render
        expect(response).not_to match(t('views.rooms.show.buttons.leave'))
      end

      it 'displays the close room button' do
        render
        expect(response).to match(t('views.rooms.show.buttons.destroy'))
        expect(response).to match(room_path(room))
      end

      it 'displays the edit room button' do
        render
        expect(response).to match(t('views.rooms.show.buttons.edit'))
        expect(response).to match(room_path(room))
        expect(response).to match('patch')
      end
    end

    context 'when the user is not admin' do
      before do
        allow(view).to receive(:current_user).and_return(user)
      end

      it 'displays the leave room button' do
        render
        expect(response).to match(t('views.rooms.show.buttons.leave'))
        expect(response).to match(leave_room_path(room))
      end

      it 'does not display the kick button' do
        render
        expect(response).not_to match(t('views.rooms.show.buttons.kick'))
      end

      it 'does not display the close room button' do
        render
        expect(response).not_to match(t('views.rooms.show.buttons.destroy'))
      end
    end
  end
end
