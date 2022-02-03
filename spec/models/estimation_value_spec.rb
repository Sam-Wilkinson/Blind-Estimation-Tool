require 'rails_helper'

RSpec.describe EstimationValue, type: :model do
  context 'when validating' do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:placement) }

    it { is_expected.to have_many(:estimations).dependent(:destroy) }
    it { is_expected.to validate_uniqueness_of(:value) }
    it { is_expected.to validate_uniqueness_of(:placement) }
  end
end
