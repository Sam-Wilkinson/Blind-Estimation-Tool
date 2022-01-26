require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'when validating' do
    subject { build(:room) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to belong_to(:admin) }
    it { is_expected.to have_and_belong_to_many(:users) }
  end

  describe 'include?' do
    let(:admin) { create(:user) }
    let(:room) { create(:room, admin: admin) }
    let(:user1) { create(:user) }

    it 'does not give access to users who are not in the room' do
      expect(room.include?(user1)).to be(false)
    end

    it 'gives access to users who are in the room' do
      room.users << user1
      expect(room.include?(user1)).to be(true)
    end

    it 'gives access to the admin of the room even if they are not a user of the room' do
      expect(room.include?(admin)).to be(true)
    end
  end

  describe 'remove_user' do
    let(:room) { create(:room) }
    let(:user) { create(:user) }

    it 'removes a users access to the room' do
      room.users << user
      room.remove_user(user)
      expect(room.users).not_to include(user)
    end
  end
end
