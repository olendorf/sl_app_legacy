# frozen_string_literal: true

# Policy for all rezzables
class Api::V1::RezzablePolicy < ApplicationPolicy
  def show?
    true
  end

  def destroy?
    show?
  end

  def update?
    return true if @user.can_be_owner?

    @user.active?
  end

  def create?
    return true if @user.can_be_owner?
    return false unless @user.active?

    user.weight_limit >= user.object_weight + record.weight
  end
end
