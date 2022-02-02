require 'rails_helper'

RSpec.describe RoomSearchService do
  describe 'search' do
    let(:text) { 'name' }
    let(:user) { create(:user) }
    let!(:room) { create(:room, name: 'room_name') }
    let!(:room2) { create(:room, name: 'another_room') }

    it 'returns rooms when the name given is similar' do
      result = described_class.new(text, 'all', user.id).search

      expect(result).to include(room)
      expect(result).not_to include(room2)
    end

    it 'does not return rooms when the name given is not similar' do
      result = described_class.new('not_similar', 'all', user.id).search

      expect(result).not_to include(room)
      expect(result).not_to include(room2)
    end

    it 'returns rooms that the user is not a part of' do
      room2.users << user
      result = described_class.new('', 'available', user.id).search
      expect(result).to include(room)
      expect(result).not_to include(room2)
    end

    it 'returns rooms that the user is a part of' do
      room.users << user
      result = described_class.new('', 'included', user.id).search

      expect(result).to include(room)
      expect(result).not_to include(room2)
    end

    it 'returns rooms that the user is an admin of' do
      room.admin = user
      room.save
      result = described_class.new('', 'admin', user.id).search

      expect(result).to include(room)
      expect(result).not_to include(room2)
    end

    it 'returns rooms that the user is an admin of and that matches the name given' do
      room.admin = user
      room.save
      result = described_class.new(text, 'admin', user.id).search

      expect(result).to include(room)
      expect(result).not_to include(room2)
    end

    it 'returns all rooms if no text is given and the filter is all' do
      result = described_class.new('', 'all', user.id).search

      expect(result).to include(room)
      expect(result).to include(room2)
    end
  end
end
