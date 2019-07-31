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
        image_tag "http://secondlife.com/app/image/#{vendor.image_key}/2"
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
        server = Rezzable::Server.find vendor.server_id
        link_to server.object_name, admin_rezzable_server_path(server)
      else
        'Unlinked'
      end
    end
    column 'Inventory' do |vendor|
      inventory = vendor.server.inventories.find_by_inventory_name(vendor.inventory_name)
      if inventory 
        link_to inventory.inventory_name, admin_analyzable_inventory_path(inventory) if inventory
      else
        'No Linked Inventory'
      end
    end
    column 'Product' do |vendor|
      product = vendor.inventory.product
      if product
        link_to product.product_name, admin_analyzable_product_path(product)
      else
        'No Linked Product'
      end
    end
    column 'Location', sortable: :region, &:slurl
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
  filter :web_object_region, as: :string, label: 'Region'
  filter :web_object_pinged_at, as: :date_range, label: 'Last Ping'
  filter :web_object_create_at, as: :date_range

  show title: :object_name do
    attributes_table do
      row 'Image' do |vendor|
        if vendor.image_key == NULL_KEY
          image_tag 'no_image_240x240.png'
        else
          image_tag "http://secondlife.com/app/image/#{vendor.image_key}/2 "
        end
      end
      row :object_name, &:object_name
      row :object_key
      row 'Server' do |vendor|
        if vendor.server
          server = vendor.user.servers.find(vendor.server_id)
          link_to server.web_object.object_name, admin_rezzable_server_path(server)
        else
          'Unlinked'
        end
      end
      row 'Inventory' do |vendor|
        inventory = vendor.server.inventories.find_by_inventory_name(vendor.inventory_name)
        if inventory 
          link_to inventory.inventory_name, admin_analyzable_inventory_path(inventory) if inventory
        else
          'No Linked Inventory'
        end
      end 
      row 'Product' do 
        product = vendor.inventory.product
        if product
          link_to product.product_name, admin_analyzable_product_path(product)
        else
          'No Linked Product'
        end
      end
      row :description
      row 'Owner', sortable: 'users.avatar_name' do |vendor|
        if vendor.user
          link_to vendor.user.avatar_name, admin_user_path(vendor.user)
        else
          'Orphan'
        end
      end
      row :location, &:slurl
      row :created_at
      row :updated_at
      row :pinged_at
      row :status do |vendor|
        if vendor.active?
          status_tag 'active', label: 'Active'
        else
          status_tag 'inactive', label: 'Inactive'
        end
      end
    end
  end

  sidebar :splits, only: %i[show edit] do
    total = 0.0
    h3 'From This Object'
    dl class: 'row' do
      resource.splits.each do |split|
        total += split.percent
        dt split.target_name
        dd "#{number_with_precision(split.percent * 100, precision: 0)}%"
      end
    end
    h3 'From User'
    dl class: 'row' do
      resource.user.splits.each do |split|
        total += split.percent
        dt split.target_name
        dd "#{number_with_precision(split.percent * 100, precision: 0)}%"
      end
    end
    h3 "Total: #{number_with_precision(total * 100, precision: 0)}%"
  end

  permit_params :object_name, :description, :image_key, :inventory_name, :server_id,
                splits_attributes: %i[id target_name
                                      target_key percent _destroy]

  form title: proc { "Edit #{resource.object_name}" } do |f|
    f.inputs do
      f.input :object_name
      f.input :description
      f.input :image_key
      f.input :server_id, label: 'Server',
                          as: :select,
                          collection: resource.user.servers.map { |s|
                                        [s.object_name, s.id]
                                      }
      f.input :inventory_name, as: :select, collection: options_for_select(
        resource.server.inventories.map(&:inventory_name),
        selected: resource.inventory_name
      )
    end
    f.has_many :splits, heading: 'Splits',
                        allow_destroy: true do |s|
      s.input :target_name, label: 'Avatar Name'
      s.input :target_key, label: 'Avatar Key'
      s.input :percent
    end
    f.actions
  end

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
