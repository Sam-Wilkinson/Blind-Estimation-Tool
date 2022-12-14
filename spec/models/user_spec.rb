require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when validating User' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    it { is_expected.to allow_value('sam_wilkinson@hotmail.com').for(:email) }
    it { is_expected.not_to allow_value('sam_wilkinson@hotmail').for(:email) }
    it { is_expected.not_to allow_value('sam_wilkinsonhotmail.com').for(:email) }
    it { is_expected.not_to allow_value('sam@wilkinson@hotmail.com').for(:email) }

    it { is_expected.to have_many(:rooms).through(:room_users) }
    it { is_expected.to have_many(:owned_rooms) }

    it { is_expected.to have_many(:estimations).dependent(:destroy) }
    it { is_expected.to have_many(:estimation_values).through(:estimations) }
    it { is_expected.to have_many(:user_stories).through(:estimations) }
  end
end
