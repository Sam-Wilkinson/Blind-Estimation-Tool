require 'rails_helper'

RSpec.describe UserStory, type: :model do
  context 'when validating' do
    subject { build(:user_story) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:room_id) }

    it { is_expected.to belong_to(:room) }
  end
end