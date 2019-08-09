# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  let(:user) { FactoryBot.create :active_user }
  let(:owner) { FactoryBot.create :owner }
  before(:each) do 
    user.managers << FactoryBot.create_list(:listable_manager, 5)
    login_as(owner, scope: :user)
  end
  
  scenario 'owner deletes a manager from the users show page' do 
    visit admin_user_path(user)
    manager = user.managers.sample
    click_on "delete_manager_#{manager.id}"
    expect(page).to have_text "Avatar removed from the list."
  end
end