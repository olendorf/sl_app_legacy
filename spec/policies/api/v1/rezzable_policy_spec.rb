# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RezzablePolicy, type: :policy do
  let(:active_user) do
    FactoryBot.create :user,  expiration_date: 1.month.from_now,
                              account_level: 1
  end

  let(:inactive_user) do
    FactoryBot.create :user,  account_level: 0
  end

  let(:web_object) { FactoryBot.build :web_object }

  subject { described_class }

  permissions :show?, :destroy? do
    context 'user is active' do
      it 'grants permission to the user' do
        expect(subject).to permit(active_user, web_object)
      end
    end

    context 'user is inactive' do
      it 'grants permission to the user ' do
        expect(subject).to permit(inactive_user, web_object)
      end
    end
  end

  permissions :update? do
    context 'user is active' do
      it 'grants permission to the user' do
        expect(subject).to permit(active_user, web_object)
      end
    end

    context 'user is inactive' do
      it 'denies permission to the user ' do
        expect(subject).to_not permit(inactive_user, web_object)
      end
    end
  end

  permissions :create? do
    context 'user is inactive' do
      it 'denies permission to the user' do
        expect(subject).to_not permit(inactive_user, web_object)
      end
    end

    context 'user is active' do
      context 'user has enough reserve object weight' do
        it 'grants permission to the user' do
          expect(subject).to permit(active_user, web_object)
        end
      end

      context 'user does not have enough reserve object weight' do
        before(:each) do
          active_user.web_objects << FactoryBot.build(:web_object)
        end
        it 'denies permission to the user' do
          expect(subject).to_not permit(active_user, web_object)
        end
      end
    end
  end
end
