class Analyzable::InventoryDecorator < ApplicationDecorator
  delegate_all
  
  def pretty_perms (who)
    output = []
    Analyzable::Inventory::PERMS.each do |perm, flag|
      output << perm if (flag & self.send("#{who}_perms")) > 0    
    end
    output.join('|')
  end

end
