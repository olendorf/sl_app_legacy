# frozen_string_literal: true

# Authorization for Rezzable::Terminals
class Api::V1::Analyzable::TransactionPolicy < ApplicationPolicy
  def create?
    return true if @user.can_be_owner?
    @user.active?
  end

  def update?
    create?
  end

  def show?
    create?
  end

  def destroy?
    create?
  end
end