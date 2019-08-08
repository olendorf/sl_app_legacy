class Api::V1::Listable::AvatarPolicy < ApplicationPolicy
  
  def index?
    create?
  end
  
  def create?
    return true if @user.can_be_owner?

    @user.active?
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
