# frozen_string_literal: true

ActiveAdmin.register Rezzable::Vendor do
  include ActiveAdmin::RezzableBehavior

  menu label: 'Vendors', parent: 'Objects'

  actions :all, except: %(new create)
  
  decorate_with Rezzable::VendorDecorator
  
  index title: 'Vendors' do
    selectable_column
    column '' do |vendor|
      if vendor.image_key == NULL_KEY
        image_tag 'no_image_240x240.png'
      else
        image_tag "http://secondlife.com/app/image/#{vendor.image_key}/2 "
      end
    end
    column 'Object Name', sortable: :object_name do |vendor|
      link_to vendor.object_name, admin_rezzable_vendor_path(vendor)
    end
    column 'Description' do |vendor|
      truncate(vendor.description, length: 10, separator: ' ')
    end
    column 'Server' do |vendor|
      if vendor.server
        link_to vendor.server.object_name, admin_rezzable_server_path(vendor.server)
      else
        'Unlinked'
      end
    end
    column 'Inventory', &:inventory_name
    column 'Location', sortable: :region, &:slurl
    column :inventory_count
    column 'Owner', sortable: 'users.avatar_name' do |vendor|
      if vendor.user
        link_to vendor.user.avatar_name, admin_user_path(vendor.user)
      else
        'Orphan'
      end
    end
    column 'Last Ping', sortable: :pinged_at do |vendor|
      if vendor.active?
        status_tag 'active', label: time_ago_in_words(vendor.pinged_at)
      else
        status_tag 'inactive', label: time_ago_in_words(vendor.pinged_at)
      end
    end
    column :created_at, sortable: :created_at
    actions
  end
  
  filter :web_object_object_name, as: :string, label: 'Object Name'
  filter :web_object_description, as: :string, label: 'Description'
  filter :web_object_user_avatar_name, as: :string, label: 'Owner'
  filter :web_object_pinged_at, as: :date_range, label: 'Last Ping'
  filter :web_object_create_at, as: :date_range

  # decorate_with Rezzable::VendorDecorator

 
  controller do
    def scoped_collection
      super.includes :user
    end

    # def update_web_object(resource)
    #   puts "would delete inventories here"
    #   super
    # end
  end
end
