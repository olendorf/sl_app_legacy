# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagePolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :home? do
    it 'grants access to everyone ' do
      expect(subject).to permit(nil, :static_page)
    end
  end
end
