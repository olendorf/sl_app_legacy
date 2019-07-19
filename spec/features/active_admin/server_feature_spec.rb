# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Server management', type: :feature do
  let(:owner) { FactoryBot.create :owner }
  let(:user) { FactoryBot.create :user }
  let(:server) { FactoryBot.create :server, user_id: user.id }
  let(:uri_regex) do
    %r{\Ahttps:\/\/sim3015.aditi.lindenlab.com:12043\/cap\/[-a-f0-9]{36}\z}
  end
  # rubocop:disable Metrics/LineLength
  let(:delete_regex) do
    %r{\Ahttps:\/\/sim3015.aditi.lindenlab.com:12043\/cap\/[-a-f0-9]{36}\/inventory\/[\S\s\+]*\z}
  end
  # rubocop:enable Metrics/LineLength

  before(:each) do
    login_as(owner, scope: :user)
  end

  scenario 'User deletes a server' do
    stub = stub_request(:delete, uri_regex)
           .with(
             headers: {
               'Accept' => 'application/json',
               'Accept-Encoding' => 'gzip, deflate',
               'Content-Type' => 'application/json',
               'Host' => 'sim3015.aditi.lindenlab.com:12043',
               'User-Agent' => 'rest-client/2.0.2 (linux-gnu x86_64) ruby/2.6.3p62',
               'X-Auth-Digest' => /[a-f0-9]{40}/,
               'X-Auth-Time' => /[0-9]{5,20}/
             }
           ).to_return(status: 200, body: '', headers: {})

    visit admin_rezzable_server_path(server)
    click_on 'Delete Rezzable Server'
    expect(page).to have_text('Server was successfully destroyed.')
    expect(stub).to have_been_requested
  end

  scenario 'User updates a server' do
    stub_request(:put, uri_regex)
      .with(
        body: /\S*/,
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip, deflate',
          'Content-Length' => /[0-9][1,6]/,
          'Content-Type' => 'application/json',
          'Host' => 'sim3015.aditi.lindenlab.com:12043',
          'User-Agent' => 'rest-client/2.0.2 (linux-gnu x86_64) ruby/2.6.3p62',
          'X-Auth-Digest' => /[a-f0-9]{40}/,
          'X-Auth-Time' => /[0-9]{5,20}/
        }
      ).to_return(status: 200, body: '', headers: {})

    visit edit_admin_rezzable_server_path(server)
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

    visit edit_admin_rezzable_server_path(server)
    first_id = server.inventories.first.id
    check 'rezzable_server_inventories_attributes_0__destroy'
    click_on 'Update Server'
    expect(page).to have_text('Server was successfully updated.')
    expect(Analyzable::Inventory.exists?(first_id)).to be_falsey
  end

  scenario 'User deletes mulitiple inventory' do
    3.times do |i|
      server.inventories << FactoryBot.create(
        :inventory, inventory_name: "inventory #{i}"
      )
    end

    stub_request(:put, uri_regex).to_return(status: 200, body: '', headers: {})

    stub_request(:delete, delete_regex).to_return(status: 200, body: '', headers: {})

    visit edit_admin_rezzable_server_path(server)
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
