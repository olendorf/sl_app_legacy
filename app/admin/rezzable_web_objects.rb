# frozen_string_literal: true

ActiveAdmin.register Rezzable::WebObject do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :object_name, :description,
              splits_attributes: %i[id target_name
                                    target_key percent _destroy]

  form title: proc { "Edit #{resource.object_name}" } do |f|
    f.inputs do
      f.input :object_name
      f.input :description
    end
    # f.has_many :splits, heading: 'Splits',
    #                     allow_destroy: true do |s|
    #   s.input :target_name, label: 'Avatar Name'
    #   s.input :target_key, label: 'Avatar Key'
    #   s.input :percent
    # end
    f.actions
  end
end
