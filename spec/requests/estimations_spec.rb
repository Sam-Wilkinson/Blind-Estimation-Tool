require 'rails_helper'

RSpec.describe 'Estimations', type: :request do
  describe 'POST /estimations' do
    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let(:estimation_value) { create(:estimation_value) }
    let(:user_story) { create(:user_story, room: room) }

    context 'when user is not in the room' do
      before do
        sign_in(user)
      end

      it 'redirects to the rooms page' do
        post estimations_path params: { estimation: { user_story_id: user_story.id } }
        expect(response).to redirect_to rooms_path
      end

      it 'sets an alert flash' do
        post estimations_path params: { estimation: { user_story_id: user_story.id } }
        expect(flash[:alert]).to be_present
      end
    end

    context 'when the user is in the room' do
      before do
        sign_in(user)
        room.users << user
      end

      it 'creates an estimation with the user, estimation_value and user_story' do
        estimations_count = Estimation.all.count
        post estimations_path params: { estimation: { user_story_id: user_story.id, estimation_value_id: estimation_value.id, user_id: user.id } }
        expect(Estimation.count).to eq(estimations_count + 1)
      end

      it 'redirects to the user_story show page' do
        post estimations_path params: { estimation: { user_story_id: user_story.id, estimation_value_id: estimation_value.id, user_id: user.id } }
        expect(response).to redirect_to user_story_path(user_story)
      end

      it 'set a notice flash' do
        post estimations_path params: { estimation: { user_story_id: user_story.id, estimation_value_id: estimation_value.id, user_id: user.id } }
        expect(flash[:notice]).to be_present
      end
    end
  end
end
