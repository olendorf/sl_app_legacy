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
