require 'rails_helper'

RSpec.describe EstimationValue, type: :model do
  context 'when validating' do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:placement) }

    it { is_expected.to have_many(:estimations).dependent(:destroy) }
    it { is_expected.to validate_uniqueness_of(:value) }
    it { is_expected.to validate_uniqueness_of(:placement) }

    it 'has a default ascending order' do
      estimation3 = create(:estimation_value, placement: 3)
      estimation1 = create(:estimation_value, placement: 1)
      estimation2 = create(:estimation_value, placement: 2)
      estimation_order_incorrect = [estimation3, estimation1, estimation2]
      estimation_order_correct = [estimation1, estimation2, estimation3]
      expect(described_class.all).to eq estimation_order_correct
      expect(described_class.all).not_to eq estimation_order_incorrect
    end
  end
end
