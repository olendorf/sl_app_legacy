# frozen_string_literal: true

# Policy for API user requsts
class Api::V1::UserPolicy < ApplicationPolicy
  def show?
    user.can_be_owner?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def create?
    true
  end
end
