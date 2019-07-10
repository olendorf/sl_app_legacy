require 'rails_helper'

RSpec.describe Analyzable::InventoryDecorator do
  describe :pretty_owner_perms do
    context 'copy trans' do 
      it 'returns the right text' do 
        perms = Analyzable::Inventory::PERMS[:copy] + 
                Analyzable::Inventory::PERMS[:transfer]
        inventory = FactoryBot.build :inventory, owner_perms: perms
        expect(
          inventory.decorate.pretty_perms(:owner)
          ).to eq 'copy|transfer'
      end
    end
    
    context 'moidfy' do 
      it 'returns the right text' do 
        perms = Analyzable::Inventory::PERMS[:modify]
        inventory = FactoryBot.build :inventory, next_perms: perms
        expect(
          inventory.decorate.pretty_perms(:next)
          ).to eq 'modify'
      end
    end
    
    context 'copy trans' do 
      it 'returns the right text' do 
        perms = Analyzable::Inventory::PERMS[:modify] + 
                Analyzable::Inventory::PERMS[:transfer]
        inventory = FactoryBot.build :inventory, owner_perms: perms
        expect(
          inventory.decorate.pretty_perms(:owner)
          ).to eq 'modify|transfer'
      end
    end
  end
end
