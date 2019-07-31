# frozen_string_literal: true

ActiveAdmin.register Analyzable::Product do
  menu label: 'Products'

  decorate_with Analyzable::ProductDecorator

  actions :all

  index title: 'Products' do
    selectable_column
    column 'Product Name', sortable: :product_name do |product|
      link_to product.product_name, admin_analyzable_product_path(product)
    end
    column 'Owner', sortable: 'users.avatar_name' do |product|
      if product.user
        link_to product.user.avatar_name, admin_user_path(product.user)
      else
        'Orphan'
      end
    end
    column :price
    column 'Aliases' do |product|
      product.aliases.size
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :user_avatar_name_contains, label: 'User Name'
  filter :product_name_contains
  filter :aliases_alias_name_contains, as: :string, label: 'Alias'
  filter :price
  filter :created_at

  show title: proc { resource.product_name } do
    attributes_table do
      row :product_name
      row :owner do |product|
        if product.user
          link_to product.user.avatar_name, admin_user_path(product.user)
        else
          'Orphan'
        end
      end
      row :price
      row :created_at
      row :updated_at
    end

    panel 'Linked Inventory' do
      linked_inventories = resource.user.inventories.where(
        inventory_name: resource.aliases.map(&:alias_name)
      ).reorder(:inventory_name)
      paginated_collection(
        linked_inventories.page(
          params[:inventory_page]
        ).per(20), param_name: 'inventory_page'
      ) do
        table_for collection.decorate do
          column 'Alias' do |inventory|
            link_to inventory.inventory_name,
                    admin_analyzable_inventory_path(inventory)
          end
          column 'Type', &:inventory_type
          column 'Owner Perms' do |inventory|
            inventory.pretty_perms(:owner)
          end
          column 'Next Perms' do |inventory|
            inventory.pretty_perms(:next)
          end
          column 'Server' do |inventory|
            link_to inventory.server.object_name,
                    admin_rezzable_server_path(inventory.server)
          end
          column '' do |inventory|
            span class: 'table_actions' do
              "#{link_to('View', admin_analyzable_inventory_path(inventory),
                         class: 'view_link member_link')}
              #{link_to('Edit', edit_admin_analyzable_inventory_path(inventory),
                        class: 'edit_link member_link')}
              #{link_to('Delete', admin_analyzable_inventory_path(inventory),
                        class: 'delete_link member_link',
                        method: :delete,
                        data: {
                          confirm: 'Are you sure you want to delete this?'
                        })}".html_safe
            end
          end
        end
      end
    end
  end

  sidebar :aliases, only: %i[show edit] do
    ul do
      resource.aliases.order(:alias_name).each do |aka|
        li aka.alias_name
      end
    end
  end

  permit_params :product_name, :price,
                aliases_attributes: %i[id alias_name _destroy]

  form title: proc { "Edit #{resource.product_name}" } do |f|
    f.inputs do
      f.input :product_name
      f.input :price
    end
    f.has_many :aliases, heading: 'Aliases',
                         new_record: true,
                         allow_destroy: true do |a|
      a.input :alias_name
    end
    actions
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
