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
    @user.active?
  end

  def create?
    return false unless @user.active?

    user.weight_limit >= user.total_object_weight + record.weight
  end
end
