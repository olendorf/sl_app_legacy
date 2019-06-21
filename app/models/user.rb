# frozen_string_literal: true

# User class from devise.
class User < ApplicationRecord
  attr_accessor :starter
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         :trackable,
         :timeoutable
         
  validates_uniqueness_of :avatar_key
  validates_presence_of :avatar_name
  validates_numericality_of :account_level, greater_than_or_equal_to: 0
  
  before_create :starter_account, if: :starter
  before_update :adjust_expiration_date, if: :will_save_change_to_account_level?

  enum role: %i[user manager owner]

  has_many :rezzable_web_objects, class_name: 'Rezzable::WebObject'

  ##
  # Creates methods to test of a user is allowed to act as a role.
  # Given ROLES = [:guest, :user, :admin, :owner], will create the methods
  # #can_be_guest?, #can_be_user?, #can_be_admin? and #can_be_owner?.
  #
  # The methods return true if the user's role is equal to or less than the
  # rank of the can_be method. So if a user is an admin, #can_be_user? or
  # #can_be_admin? would return true, but
  # can_be_owner? would return false.
  #
  User.roles.each do |role_name, value|
    define_method("can_be_#{role_name}?") do
      value <= self.class.roles[role]
    end
  end
  
  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  def will_save_change_to_email?
    false
  end
  
  private
  
  def starter_account
    self.account_level = 1 if self.account_level == 0 
    self.expiration_date = self.expiration_date = 4.weeks.from_now
  end
  
  def adjust_expiration_date
    if self.account_level_was == 0
      raise ArgumentError, I18n.t('api.user.update.account_level.inactive_account')
    end
    if self.account_level == 0
      self.expiration_date = nil
    else
      self.update_column(:expiration_date, 
                         Time.now + (self.expiration_date - Time.now) * 
                         (self.account_level_was.to_f/self.account_level))
    end 
  end
  
end
