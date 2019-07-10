class Analyzable::InventoryDecorator < ApplicationDecorator
  delegate_all
  
  def pretty_perms (flags)
    output = []
    Analyzable::Inventory::PERMS.each do |perm, flag|
      output << perm if (flag & flags) > 0    
    end
    output.join('|')
  end
  

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  def perm_string
    
  end

end
