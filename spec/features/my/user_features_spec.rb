# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  let(:user) { FactoryBot.create :user, account_level: 0, expiration_date: nil }

  before(:each) do
    login_as(user, scope: :user)
  end

  scenario 'user deletes a manager from the users show page' do
    user.managers << FactoryBot.create_list(:listed_manager, 5)
    visit my_dashboard_path
    manager = user.managers.sample
    click_on "delete_manager_#{manager.id}"
    expect(page).to have_text 'Avatar removed from the list.'
    expect(Listable::Avatar.exists?(manager.id)).to be_falsey
  end
end
