# frozen_string_literal: true

module Api
  module V1
    module Analyzable
      # Controller for requests from SL for Analyzable::Inventory
      class InventoriesController < Api::V1::AnalyzableController
        def create
          authorize ::Analyzable::Inventory
          begin
            @inventory = @requesting_object.actable.inventories
                                           .find_by_inventory_name! atts['inventory_name']
            update
          rescue ActiveRecord::RecordNotFound
            @requesting_object.actable
                              .inventories << ::Analyzable::Inventory.create!(atts)
            render json: { message: 'Created' }, status: :created
          end
        end

        def index
          authorize ::Analyzable::Inventory
          params['inventory_page'] ||= 1
          page = @requesting_object.actable.inventories
                                   .page(params['inventory_page']).per(9)
          data = paged_data(page)
          if page.current_page > page.total_pages
            raise(ActiveRecord::RecordNotFound, 'Page does not exist') && return
          end
          render json: { message: 'OK', data: data }
        end
        # rubocop:enable Metrics/MethodLength

        def show
          authorize @requesting_object
          load_inventory
          render json: { message: 'OK',
                         data: { created_at: @inventory.created_at.to_s(:long) } }
        end

        def update
          authorize @requesting_object
          load_inventory unless @inventory
          render json: { message: 'OK' }
        end

        # rubocop:disable Metrics/MethodLength
        def destroy
          authorize @requesting_object.user
          msg = 'OK'
          if params['id'] == 'all'
            @requesting_object.actable.inventories.destroy_all
          else
            load_inventory
            @inventory.destroy!
            msg = I18n.t('api.analyzable.inventory.destroy.success',
                         inventory_name: @inventory.inventory_name)
          end
          render json: { message: msg }
        end

        # rubocop:enable Metrics/MethodLength
        private

        def paged_data(page)
          {
            inventory: page.map(&:inventory_name),
            current_page: page.current_page,
            next_page: page.next_page,
            prev_page: page.prev_page,
            total_pages: page.total_pages
          }
        end

        def atts
          JSON.parse(request.raw_post)
        end

        def api_key
          @requesting_object.api_key
        end

        def load_inventory
          @inventory = @requesting_object.actable.inventories
                                         .find_by_inventory_name! params['id']
        end
      end
    end
  end
end
