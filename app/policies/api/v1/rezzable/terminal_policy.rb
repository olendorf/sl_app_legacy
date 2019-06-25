# frozen_string_literal: true

# Authorization for Rezzable::Terminals
class Api::V1::Rezzable::TerminalPolicy < Api::V1::RezzablePolicy
  def create?
    @user.can_be_owner?
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
