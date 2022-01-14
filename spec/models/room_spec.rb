require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'when validating' do
    subject { build(:room) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to belong_to(:admin) }
    it { is_expected.to have_and_belong_to_many(:users) }
  end
end
