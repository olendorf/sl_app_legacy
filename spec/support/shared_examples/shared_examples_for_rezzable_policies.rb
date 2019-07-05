# frozen_string_literal: true

RSpec.shared_examples 'it has a rezzable policy' do |model_name|
  let(:active_user) { FactoryBot.build :active_user }

  let(:inactive_user) { FactoryBot.build :inactive_user }

  let(:owner) { FactoryBot.build :owner }

  let(:web_object) { FactoryBot.build model_name }

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

    it 'grants permission to an owner' do
      expect(subject).to permit owner, web_object
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

    it 'grants permission to an owner' do
      expect(subject).to permit owner, web_object
    end
  end

  permissions :create? do
    it 'grants permission to an owner' do
      expect(subject).to permit owner, web_object
    end

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
