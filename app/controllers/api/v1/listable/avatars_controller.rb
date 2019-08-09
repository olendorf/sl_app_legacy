# frozen_string_literal: true

module Api
  module V1
    module Listable
      # Handles requests from inworld to handle listable avatars
      class AvatarsController < Api::V1::ApiController
        skip_before_action :load_requesting_object, except: [:create]
        prepend_before_action :load_requesting_object

        def create
          authorize Listable::Avatar
          @requesting_object.user.managers << Listable::Avatar.create!(atts)
          render json: { message: 'Created' }, status: :created
        end

        def index
          authorize Listable::Avatar
          params['page'] ||= 1
          render json: {
            message: 'OK',
            data: paginate_collection(
              @requesting_object.user.managers,
              params['page']
            )
          },
                 status: :ok
        end

        def paginate_collection(collection, page)
          page_data = collection.page(page).per(9)
          {
            avatars: page_data.map(&:avatar_name),
            total_pages: page_data.total_pages,
            current_page: page_data.current_page,
            next_page: page_data.next_page,
            prev_page: page_data.prev_page
          }
        end

        def destroy
          @listed_avatar = @requesting_object.user.managers
                                             .find_by_avatar_name!(
                                               CGI.unescape(params[:id])
                                             )
          authorize @listed_avatar
          @listed_avatar.destroy!
          render json: {
            message: I18n.t('api.listable.avatar.destroy.success')
          }
        end

        def atts
          JSON.parse(request.raw_post)
        end

        def api_key
          @requesting_object.api_key
        end
      end
    end
  end
end
