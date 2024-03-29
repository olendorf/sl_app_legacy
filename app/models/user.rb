# frozen_string_literal: true

# User class from devise.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  attr_accessor :starter, :payment, :period

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
  before_update :handle_payment, if: :payment
  after_save :update_weight

  enum role: %i[user manager owner]

  has_many :web_objects, class_name: 'Rezzable::WebObject', dependent: :destroy
  has_many :transactions, class_name: 'Analyzable::Transaction', dependent: :destroy
  has_many :splits, as: :splittable, class_name: 'Analyzable::Split', dependent: :destroy
  has_many :products, class_name: 'Analyzable::Product', dependent: :destroy
  has_many :managers, as: :listable, class_name: 'Listable::Avatar', dependent: :destroy

  accepts_nested_attributes_for :splits, allow_destroy: true

  has_paper_trail ignore: %i[object_weight expiration_date
                             remember_created_at sign_in_count
                             current_sign_in_at last_sign_in_at
                             updated_at]

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

  def analyzable_transactions
    transactions
  end

  def analyzable_inventories
    inventories
  end

  def inventories
    Analyzable::Inventory.where(server_id: servers.map(&:id)).order(:id)
  end

  def rezzable_servers
    servers
  end

  def servers
    Rezzable::Server.where(user_id: id)
  end

  def rezzable_vendors
    vendors
  end

  def vendors
    Rezzable::Vendor.where(user_id: id)
  end

  def balance
    return 0 if transactions.size.zero?

    transactions.last.balance
  end

  def weight_limit
    account_level * Settings.account.max_weight_per_level
  end

  def update_weight
    web_objects.map(&:weight).sum
  end

  def active?
    return false if account_level.zero?
    return false if expiration_date < Time.now

    true
  end

  def can_add_object?(_web_object)
    return false unless active?

    true
  end

  def object_weight
    web_objects.map(&:weight).sum
  end

  ######
  ## These are here to fix stuff with devise since we can't and don't
  ## use email as our authentication key.
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
  #####
  #####

  private

  # Allows for starter packages to be sold with free time.
  def starter_account
    self.account_level = 1 if account_level.zero?
    self.expiration_date = 1.month.from_now
  end

  # rubocop:disable Metrics/AbcSize

  # Need to do this when changing account levels.
  def adjust_expiration_date
    if account_level_was.zero? && (expiration_date.nil? || expiration_date < Time.now)
      raise ArgumentError, I18n.t('api.user.update.account_level.inactive_account')
    end

    if account_level.zero?
      self.expiration_date = nil
    else
      update_column(:expiration_date,
                    Time.now + (expiration_date - Time.now) *
                    (account_level_was.to_f / account_level))
    end
  end

  # Handles payments. Account level is set to one if it is zero, payment is
  # validated to be correct.
  def handle_payment
    self.account_level = 1 if account_level.zero?
    if payment == Settings.account.price_per_level[period] * account_level
      self.expiration_date = DateTime.now if
        expiration_date.nil? || account_level.zero?
      self.expiration_date = expiration_date + period.months
    else
      self.account_level = account_level_was # need to reset this, kinda weird.
      raise ArgumentError, I18n.t('api.user.update.payment.invalid')
    end
  end
  # rubocop:enable Metrics/AbcSize
end
