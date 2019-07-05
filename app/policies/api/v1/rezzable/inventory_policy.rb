# frozen_string_literal: true

# Policy for requests from SL for inventory.
class Api::V1::Rezzable::InventoryPolicy < ApplicationPolicy
  def create?
    return true if @user.can_be_owner?

    @user.active?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
