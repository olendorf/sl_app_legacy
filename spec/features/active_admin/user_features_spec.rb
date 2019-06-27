require 'rails_helper'

RSpec.feature "User management", type: :feature do 
  let(:user) { FactoryBot.create :user, account_level: 0, expiration_date: nil }
  let(:owner) {FactoryBot.create :owner }

  before(:each) do 
    login_as(owner, scope: :user)
  end 
  
  scenario 'user attempts to increase account level with inactive account' do 
    visit edit_admin_user_path(user)
    fill_in 'Account level', with: 2
    click_on 'Update User'
    expect(page).to have_text('A payment is required to activate this account.')
  end

end