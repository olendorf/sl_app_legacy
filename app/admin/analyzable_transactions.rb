ActiveAdmin.register Analyzable::Transaction do
  
  menu label: 'Transactions', parent: 'Data'
  
  actions :all, except: [:destroy, :new, :create]
  
  index title: 'Transactions' do 
    selectable_column
    id_column
    column :amount
    column "User's balance", :balance
    column 'User' do |transaction|
      link_to transaction.user.avatar_name, admin_user_path(transaction.user)
    end
    column 'Object' do |transaction|
      if transaction.web_object
        link_to transaction.web_object.object_name, send("admin_#{transaction.web_object.actable.class.name.underscore.gsub('/', '_')}_path", transaction.web_object)
      else
        'Web Generated'
      end
    end
    
    actions
    
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
