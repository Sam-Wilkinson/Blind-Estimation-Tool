require 'rails_helper'

RSpec.describe 'shared/_header', type: :view do
  describe 'when displaying header' do
    before do
      allow(view).to receive(:current_user).and_return(nil)
      render
    end

    it 'shows the home link' do
      expect(rendered).to match(home_path)
    end

    it 'shows the about link' do
      expect(rendered).to match(about_path)
    end

    it 'shows the help link' do
      expect(rendered).to match(help_path)
    end
  end

  describe 'when user not logged in' do
    before do
      allow(view).to receive(:current_user).and_return(nil)
      render
    end

    it 'shows the log in button' do
      expect(rendered).to match(new_user_session_path)
    end

    it 'shows the sign up button' do
      expect(rendered).to match(new_user_registration_path)
    end

    it "doesn't show the log out button" do
      expect(rendered).not_to match(destroy_user_session_path)
    end

    it "doesn't show the edit button" do
      expect(rendered).not_to match(edit_user_registration_path)
    end
  end

  describe 'when user is logged in' do
    let(:user) { create(:user) }

    before do
      allow(view).to receive(:current_user).and_return(user)
      render
    end

    it 'does not show the log in button' do
      expect(rendered).not_to match(new_user_session_path)
    end

    it 'does not shows the sign up button' do
      expect(rendered).not_to match(new_user_registration_path)
    end

    it 'shows the log out button' do
      expect(rendered).to match(destroy_user_session_path)
    end

    it 'shows the edit button' do
      expect(rendered).to match(edit_user_registration_path)
    end
  end
end
