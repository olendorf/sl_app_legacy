# frozen_string_literal: true

# Policy for requests from SL for inventory.
class Api::V1::Analyzable::InventoryPolicy < ApplicationPolicy
  def create?
    return true if @user.can_be_owner?

    @user.active?
  end

  def index?
    create?
  end

  def show?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
