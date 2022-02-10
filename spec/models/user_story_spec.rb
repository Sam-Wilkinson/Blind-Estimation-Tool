require 'rails_helper'

RSpec.describe UserStory, type: :model do
  context 'when validating' do
    subject { build(:user_story) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:room_id) }

    it { is_expected.to belong_to(:room) }

    it { is_expected.to have_many(:estimations).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:estimations) }
    it { is_expected.to have_many(:estimation_values).through(:estimations) }
    it { is_expected.to belong_to(:estimation_value).optional }
  end

  describe 'all_users_have_estimated?' do
    it 'tells you if all the users who are expected to estimate have' do
      user = create(:user)
      admin = create(:user)
      room = create(:room, admin: admin)
      room.users << user
      user_story = create(:user_story, room: room)
      create(:estimation, user: admin, user_story: user_story)
      expect(user_story.all_users_have_estimated?).to be(false)
      create(:estimation, user: user, user_story: user_story)
      user_story.reload
      expect(user_story.all_users_have_estimated?).to be(true)
    end
  end

  describe 'update_consensus' do
    context 'when the estimations are acceptable' do
      it 'sets the user story estimation value' do
        user = create(:user)
        admin = create(:user)
        room = create(:room, admin: admin)
        room.users << user
        user_story = create(:user_story, room: room)
        estimation_value = create(:estimation_value, placement: 2)
        create(:estimation, user: admin, user_story: user_story, estimation_value: estimation_value)
        create(:estimation, user: user, user_story: user_story, estimation_value: estimation_value)

        user_story.update_consensus

        expect(described_class.find(user_story.id).estimation_value).to eq(estimation_value)
      end

      it 'sets the user story estimation value to the highest placed estimation value' do
        user = create(:user)
        admin = create(:user)
        room = create(:room, admin: admin)
        room.users << user
        user_story = create(:user_story, room: room)
        estimation_value1 = create(:estimation_value, placement: 3)
        estimation_value2 = create(:estimation_value, placement: 4)
        create(:estimation, user: admin, user_story: user_story, estimation_value: estimation_value1)
        create(:estimation, user: user, user_story: user_story, estimation_value: estimation_value2)

        user_story.update_consensus

        expect(described_class.find(user_story.id).estimation_value).to eq(estimation_value2)
        expect(described_class.find(user_story.id).estimation_value).not_to eq(estimation_value1)
      end
    end

    context 'when estimations are not within accepted range' do
      it 'does not set the user story estimation value' do
        user = create(:user)
        admin = create(:user)
        room = create(:room, admin: admin)
        room.users << user
        user_story = create(:user_story, room: room)
        estimation_value1 = create(:estimation_value, placement: 3)
        estimation_value2 = create(:estimation_value, placement: 5)
        create(:estimation, user: admin, user_story: user_story, estimation_value: estimation_value1)
        create(:estimation, user: user, user_story: user_story, estimation_value: estimation_value2)

        user_story.update_consensus

        expect(described_class.find(user_story.id).estimation_value).to eq(nil)
        expect(described_class.find(user_story.id).estimation_value).not_to eq(estimation_value1)
        expect(described_class.find(user_story.id).estimation_value).not_to eq(estimation_value2)
      end

      it 'marks the user story as estimated' do
        user = create(:user)
        admin = create(:user)
        room = create(:room, admin: admin)
        room.users << user
        user_story = create(:user_story, room: room)
        estimation_value1 = create(:estimation_value, placement: 3)
        estimation_value2 = create(:estimation_value, placement: 5)
        create(:estimation, user: admin, user_story: user_story, estimation_value: estimation_value1)
        create(:estimation, user: user, user_story: user_story, estimation_value: estimation_value2)

        user_story.update_consensus
        user_story.reload
        expect(user_story.is_estimated).to be_truthy
        expect(user_story.is_estimated).not_to be_falsey
      end
    end

    context 'when the users have not yet estimated' do
      it 'does not change the user story estimation value' do
        user_story = create(:user_story)
        user_story.update_consensus
        expect(described_class.find(user_story.id).estimation_value).to be_nil
        estimation_value = create(:estimation_value)
        user_story.update(estimation_value: estimation_value)
        user_story.update_consensus
        expect(described_class.find(user_story.id).estimation_value).to eq(estimation_value)
      end

      it 'does not change the user story estimation status' do
        user_story = create(:user_story, is_estimated: false)
        user_story.update_consensus
        user_story.reload
        expect(user_story.is_estimated).not_to be_truthy
        expect(user_story.is_estimated).to be_falsey

        user_story.update(is_estimated: true)
        user_story.update_consensus
        user_story.reload
        expect(user_story.is_estimated).not_to be_falsey
        expect(user_story.is_estimated).to be_truthy
      end
    end
  end

  describe 'delete_estimations' do
    it 'destroys all the estimations on the user_story' do
      user_story = create(:user_story)
      user_story.estimations << create(:estimation, user_story: user_story)
      user_story.delete_estimations
      user_story.reload
      expect(user_story.estimations).to be_empty
    end
  end
end
