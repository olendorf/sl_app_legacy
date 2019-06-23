require 'rails_helper'

RSpec.describe "layouts/application.html.erb", type: :view do
  let(:user) { FactoryBot.create :user }
  
  context 'user is signed in' do 
    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
    end 
    
    it 'shows sign out link' do 
      render
      expect(rendered).to have_link('Sign Out')
    end 
    
    it 'does not show sign in link' do 
      render
      expect(rendered).to_not have_link('Sign In')
    end
  end
  
  context 'user is not signed in' do 
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end 
    
    it 'shows sign in link' do 
      render
      expect(rendered).to have_link('Sign In')
      expect(rendered).to_not have_link('Sign Out')
    end 
    
    it 'does not show sign out link' do 
      render
      expect(rendered).to_not have_link('Sign Out')
    end
  end
end
