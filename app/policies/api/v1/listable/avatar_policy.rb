# frozen_string_literal: true

# Authorization for inworld listable avatar requests
class Api::V1::Listable::AvatarPolicy < ApplicationPolicy
  def index?
    create?
  end

  def create?
    return true if @user.can_be_owner?

    @user.active?
  end

  def destroy?
    create?
  end
  
  def show?
    create?
  end
end
