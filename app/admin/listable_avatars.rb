ActiveAdmin.register Listable::Avatar do
  
  menu false
  
  
  actions :destroy
  
  config.batch_actions = false
  
  controller do 
    
    def destroy
      destroy! do |format|
        flash.notice = t('active_admin.avatar.destroy.success')
        format.html do 
          redirect_back(
            fallback_location: admin_users_path
          )
        end 
      end 
    end 
  end
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

end
