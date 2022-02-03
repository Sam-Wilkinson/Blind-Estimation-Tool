require 'rails_helper'

RSpec.describe Estimation, type: :model do
  subject { create(:estimation) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:estimation_value) }
  it { is_expected.to belong_to(:user_story) }

  it { is_expected.to validate_uniqueness_of(:user_story).scoped_to(:user_id) }
end
