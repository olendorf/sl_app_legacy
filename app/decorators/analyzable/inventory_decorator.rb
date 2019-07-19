# frozen_string_literal: true

module Analyzable
  # Decorator class for Analyzable::Inventory
  class InventoryDecorator < ApplicationDecorator
    delegate_all

    def pretty_perms(who)
      output = []
      Analyzable::Inventory::PERMS.each do |perm, flag|
        output << perm if (flag & send("#{who}_perms")).positive?
      end
      output.join('|')
    end
  end
end
