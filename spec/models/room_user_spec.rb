require 'rails_helper'

RSpec.describe RoomUser, type: :model do
  it { is_expected.to belong_to(:room)  }
  it { is_expected.to belong_to(:user)  }
end
