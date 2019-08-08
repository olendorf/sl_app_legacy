class Api::V1::Listable::AvatarPolicy < ApplicationPolicy
  
  def index?
    create?
  end
  
  def create?
    @user.active?
  end

  def destroy?
    create?
  end
end
