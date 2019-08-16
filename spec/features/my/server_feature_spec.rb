# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Server management', type: :feature do
  let(:owner) { FactoryBot.create :owner }
  let(:user) { FactoryBot.create :user }
  let(:server) { FactoryBot.create :server, user_id: user.id }
  let(:uri_regex) do
    %r{
        \Ahttps:\/\/sim3015.aditi.lindenlab.com:12043\/cap\/[-a-f0-9]{36}
        \?auth_digest=[a-f0-9]+&auth_time=[0-9]+\z
    }x
  end

  let(:delete_regex) do
    %r{
        \Ahttps:\/\/sim3015.aditi.lindenlab.com:12043\/cap\/[-a-f0-9]{36}
        \/inventory\/[\S\s\+]*\?auth_digest=[a-f0-9]+&auth_time=[0-9]+\z
    }x
  end

  before(:each) do
    login_as(user, scope: :user)
  end

  scenario 'User deletes a server' do
    stub = stub_request(:delete, uri_regex)
           .to_return(status: 200, body: '', headers: {})

    visit my_rezzable_server_path(server)
    click_on 'Delete Rezzable Server'
    expect(page).to have_text('Server was successfully destroyed.')
    expect(stub).to have_been_requested
  end

  scenario 'User updates a server' do
    stub_request(:put, uri_regex)
      .with(body: /\S*/).to_return(status: 200, body: '', headers: {})

    visit edit_my_rezzable_server_path(server)
    fill_in 'Object name', with: 'foo'
    fill_in 'Description', with: 'bar'
    click_on 'Update Server'
    expect(page).to have_text('Server was successfully updated.')
  end

  scenario 'User deletes one inventory' do
    3.times do |i|
      server.inventories << FactoryBot.create(
        :inventory, inventory_name: "inventory #{i}"
      )
    end

    stub_request(:put, uri_regex).to_return(status: 200, body: '', headers: {})

    stub_request(:delete, delete_regex).to_return(status: 200, body: '', headers: {})

    visit edit_my_rezzable_server_path(server)
    first_id = server.inventories.first.id
    check 'rezzable_server_inventories_attributes_0__destroy'
    click_on 'Update Server'
    expect(page).to have_text('Server was successfully updated.')
    expect(Analyzable::Inventory.exists?(first_id)).to be_falsey
  end

  scenario 'User changes inventory server' do
    3.times do |i|
      server.inventories << FactoryBot.create(
        :inventory, inventory_name: "inventory #{i}"
      )
    end

    3.times do |_i|
      user.web_objects << FactoryBot.build(:server)
    end

    inv_uri_regex = /\A[\S\s]+\?auth_digest=[a-f0-9]+&auth_time=[0-9]+\z/

    stub_request(:post, inv_uri_regex)
      .with(
        body: "{\"target_key\":\"#{Rezzable::Server.last.object_key}\"," \
              "\"inventory_name\":\"#{server.inventories.first.inventory_name}\"}"
      ).to_return(status: 200, body: '', headers: {})

    visit edit_my_analyzable_inventory_path(server.inventories.first)

    select Rezzable::Server.last.object_name, from: 'analyzable_inventory_server_id'

    click_on 'Update Inventory'

    expect(page).to have_text('Inventory was successfully transferred.')
  end

  scenario 'user deletes inventory for show page panel' do
    stub_request(:delete, delete_regex).to_return(status: 200, body: '', headers: {})
    3.times do |i|
      server.inventories << FactoryBot.create(
        :inventory, inventory_name: "inventory #{i}"
      )
    end
    visit my_rezzable_server_path(server)
    find(
      "#analyzable_inventory_#{Analyzable::Inventory.second.id} a.delete_link.member_link"
    ).click
    expect(page).to have_text('Inventory was successfully deleted.')
  end

  scenario 'User deletes mulitiple inventory' do
    3.times do |i|
      server.inventories << FactoryBot.create(
        :inventory, inventory_name: "inventory #{i}"
      )
    end

    stub_request(:put, uri_regex).to_return(status: 200, body: '', headers: {})

    stub_request(:delete, delete_regex).to_return(status: 200, body: '', headers: {})

    visit edit_my_rezzable_server_path(server)
    first_id = server.inventories.first.id
    third_id = server.inventories.third.id
    check 'rezzable_server_inventories_attributes_0__destroy'
    check 'rezzable_server_inventories_attributes_2__destroy'
    click_on 'Update Server'
    expect(page).to have_text('Server was successfully updated.')
    expect(Analyzable::Inventory.exists?(first_id)).to be_falsey
    expect(Analyzable::Inventory.exists?(third_id)).to be_falsey
  end
end
