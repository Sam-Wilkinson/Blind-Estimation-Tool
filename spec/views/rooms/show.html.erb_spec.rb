require 'rails_helper'

RSpec.describe 'rooms/show', type: :view do
  let(:admin) { create(:user) }
  let(:user) { create(:user) }
  let(:room) { create(:room, admin: admin) }

  before do
    assign(:room, room)
    assign(:user_story, UserStory.new)
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
        expect(response).to match(t('helpers.submit.room.update'))
        expect(response).to match(room_path(room))
      end
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

  context 'when the user is admin' do
    before do
      allow(view).to receive(:current_user).and_return(admin)
    end

    it 'displays the create user story button' do
      render
      expect(response).to match(t('helpers.submit.user_story.create'))
      expect(response).to match(user_stories_path)
    end

    it 'contains the user_stories modal' do
      render
      expect(response).to render_template(partial: 'user_stories/_modal')
    end
  end

  context 'when there are user stories' do
    let(:user_story) { create(:user_story, room: room) }

    before do
      allow(view).to receive(:current_user).and_return(user)
      assign(:user_story, user_story)
    end

    it 'shows the user stories titles' do
      render
      expect(rendered).to match(user_story.title)
    end

    it 'has paths to the user story show page' do
      render
      expect(rendered).to match(user_story_path(user_story))
    end

    it 'displays the show user story button' do
      render
      expect(rendered).to match(t('views.rooms.show.buttons.user_story.show'))
    end
  end

  context 'when there are no user stories' do
    it 'displays the no user stories text' do
      allow(view).to receive(:current_user).and_return(user)
      render
      expect(rendered).to match(t('views.rooms.show.user_stories.no_stories'))
    end
  end
end
