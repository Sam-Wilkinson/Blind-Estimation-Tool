require 'rails_helper'

RSpec.describe 'UserStories', type: :request do
  describe 'POST /userstories' do
    let(:user) { create(:user) }
    let(:admin) { create(:user) }
    let(:room) { create(:room, admin: admin) }

    context 'when user is not room admin' do
      before do
        sign_in(user)
      end

      it 'does not create a user story' do
        params = {
          user_story: {
            title: Faker::Lorem.sentence
          },
          room_id: room.id
        }
        post user_stories_path, params: params
        expect(UserStory.all).to be_empty
      end

      it 'flashes an error message' do
        params = {
          user_story: {
            title: Faker::Lorem.sentence
          },
          room_id: room.id
        }
        post user_stories_path, params: params
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user is room admin' do
      before do
        sign_in(admin)
      end

      it 'creates a user story' do
        params = {
          user_story: {
            title: Faker::Lorem.sentence
          },
          room_id: room.id
        }
        post user_stories_path, params: params
        expect(UserStory.all).not_to be_empty
      end

      it 'flashes a success if the request is valid' do
        params = {
          user_story: {
            title: Faker::Lorem.sentence
          },
          room_id: room.id
        }
        post user_stories_path, params: params
        expect(flash[:notice]).to be_present
      end

      it 'flashes a warning if the title is empty' do
        params = {
          user_story: {
            title: nil
          },
          room_id: room.id
        }
        post user_stories_path, params: params
        expect(flash[:warning]).to be_present
      end
    end

    it 'redirects to the room page' do
      sign_in(admin)
      params = {
        user_story: {
          title: Faker::Lorem.sentence
        },
        room_id: room.id
      }
      post user_stories_path, params: params
      expect(response).to redirect_to room_path(room)
    end
  end

  describe 'GET /user_story' do
    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let(:user_story) { create(:user_story, room: room) }

    before do
      sign_in(user)
    end

    context 'when the user is part of the room' do
      it 'displays the user story show page' do
        room.users << user
        get user_story_path(user_story)
        expect(response).to render_template('show')
      end
    end

    context 'when the user is not part of the room' do
      it 'redirects to the rooms path' do
        get user_story_path(user_story)
        expect(response).to redirect_to rooms_path
      end

      it 'flashes an error' do
        get user_story_path(user_story)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH /user_story' do
    let(:user) { create(:user) }
    let(:room) { create(:room, admin: user) }
    let(:user_story) { create(:user_story, room: room) }

    before do
      sign_in(user)
    end

    it 'updates estimation of the user_story' do
      patch user_story_path(user_story,
                            params: { room_id: room.id, user_story: { title: user_story.title, description: "#{user_story.description}a" } })
      expect(UserStory.find(user_story.id).description).not_to eq(user_story.description)
      expect(UserStory.find(user_story.id).description).to eq("#{user_story.description}a")
    end

    it 'updates the title of the user_story' do
      patch user_story_path(user_story,
                            params: { room_id: room.id, user_story: { title: "#{user_story.title}a", description: user_story.description } })
      expect(UserStory.find(user_story.id).title).not_to eq(user_story.title)
      expect(UserStory.find(user_story.id).title).to eq("#{user_story.title}a")
    end

    it 'redirects to the user story show page' do
      patch user_story_path(user_story, params: { room_id: room.id, user_story: { title: user_story.title, description: user_story.description } })
      expect(response).to redirect_to user_story
    end

    it 'flashes a success message' do
      patch user_story_path(user_story, params: { room_id: room.id, user_story: { title: user_story.title, description: user_story.description } })
      follow_redirect!
      expect(flash[:notice]).to be_present
    end
  end

  describe 'DELETE /user_story' do
    let(:user) { create(:user) }
    let(:room) { create(:room, admin: user) }
    let(:user_story) { create(:user_story, room: room) }

    before do
      sign_in(user)
    end

    it 'deletes the user_story' do
      delete user_story_path(user_story, params: { room_id: room.id })
      expect(UserStory.all).not_to include(user_story)
    end

    it 'redirects to room page' do
      delete user_story_path(user_story, params: { room_id: room.id })
      expect(response).to redirect_to room
    end

    it 'flashes a success message' do
      delete user_story_path(user_story, params: { room_id: room.id })
      follow_redirect!
      expect(flash[:notice]).to be_present
    end
  end
end
