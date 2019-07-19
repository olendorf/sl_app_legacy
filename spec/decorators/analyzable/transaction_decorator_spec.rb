# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::TransactionDecorator do
  let(:user) { FactoryBot.create :active_user }
  let(:web_object) { FactoryBot.create :server, user_id: user.id }

  describe :source_link do
    it 'should return the link when the object exists' do
      transaction = FactoryBot.create(:transaction)
      web_object.transactions << transaction
      web_object.transactions.last.decorate

      expect(
        Capybara.string(web_object.transactions.last.decorate.source_link)
      ).to have_link(
        web_object.object_name, href: admin_rezzable_server_path(web_object.id)
      )
    end

    it 'should return Web Generated when no object exists' do
      transaction = FactoryBot.build(:transaction).decorate
      expect(transaction.source_link).to eq 'Web Generated'
    end
  end
end
