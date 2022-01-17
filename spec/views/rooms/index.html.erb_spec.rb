require 'rails_helper'

RSpec.describe 'rooms/index', type: :view do
  let(:user) { create(:user) }

  it 'shows the title' do
    render
    expect(rendered).to match(t('views.rooms.index.title'))
  end

  it 'shows the create button' do
    render
    expect(rendered).to match(t('views.rooms.index.buttons.create'))
  end

  context 'when there are no rooms' do
    it 'shows the apoligies message' do
      render
      expect(rendered).to match(t('views.rooms.index.available_rooms.no_rooms'))
    end
  end

  context 'when there are rooms' do
    let(:rooms) {create_list(:room, 5)}

    before do
      assign(:rooms, rooms)
      allow(view).to receive(:current_user).and_return(user)
    end

    it 'shows the room name column title' do
      render
      expect(rendered).to match(t('active_record.attributes.room.name'))
    end

    it 'shows the room admin column title' do
      render
      expect(rendered).to match(t('active_record.attributes.room.admin'))
    end

    it 'shows the room options column title' do
      render
      expect(rendered).to match(t('views.rooms.index.table.titles.options'))
    end

    it 'shows the rooms' do
      render
      rooms.each do |room|
        expect(rendered).to match(room.name)
      end
    end
  end

  context 'when the user has not joined a room' do
    let(:room) { create(:room) }

    before do
      assign(:rooms, [room])
      allow(view).to receive(:current_user).and_return(user)
    end

    it 'shows the room join button' do
      render
      expect(rendered).to match(t('views.rooms.index.buttons.join'))
    end
  end

  context 'when the user has joined a room' do
    let(:room) { create(:room) }

    before do
      assign(:rooms, [room])
      allow(view).to receive(:current_user).and_return(user)
      room.users << user
    end

    it 'shows the room enter button' do
      render
      expect(rendered).to match(t('views.rooms.index.buttons.enter'))
    end
  end
end
