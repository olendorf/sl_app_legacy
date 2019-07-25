# frozen_string_literal: true

# Authorization for Products
class Api::V1::Analyzable::ProductPolicy < ApplicationPolicy
  def show?
    return true if @user.can_be_owner?

    @user.active?
  end
end
