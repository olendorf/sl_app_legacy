# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::TransactionDecorator do
  let(:user) { FactoryBot.create :active_user }
  let(:web_object) { FactoryBot.create :web_object, user_id: user.id }

  describe :source_link do
    it 'should return the link when the object exists' do
      transaction = FactoryBot.build(:transaction, rezzable_id: web_object.id).decorate
      expect(
        Capybara.string(transaction.source_link)
      ).to have_link(
        web_object.object_name, href: admin_rezzable_web_object_path(web_object)
      )
    end

    it 'should return Web Generated when no object exists' do
      transaction = FactoryBot.build(:transaction).decorate
      expect(transaction.source_link).to eq 'Web Generated'
    end
  end
end
