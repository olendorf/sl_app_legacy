# frozen_string_literal: true

module Api
  module V1
    module Listable
      # Handles requests from inworld to handle listable avatars
      class ManagersController < Api::V1::ApiController
        skip_before_action :load_requesting_object, except: [:create]
        prepend_before_action :load_requesting_object

        def create
          authorize ::Listable::Avatar, policy_class: Api::V1::Listable::AvatarPolicy
          @requesting_object.user.managers << ::Listable::Avatar.create!(atts)
          render json: { message: 'Created' }, status: :created
        end

        def index
          authorize ::Listable::Avatar, policy_class: Api::V1::Listable::AvatarPolicy
          render json: {
            message: 'OK',
            data: { avatars: @requesting_object.user.managers.map(&:avatar_name) }
          }, status: :ok
        end

        def show
          load_manager
          authorize @manager, policy_class: Api::V1::Listable::AvatarPolicy
          render json: { message: 'OK' }
        end

        def destroy
          load_manager
          authorize @manager, policy_class: Api::V1::Listable::AvatarPolicy
          @manager.destroy!
          render json: {
            message: I18n.t('api.listable.manager.destroy.success',
                            manager: @manager.avatar_name)
          }
        end

        def load_manager
          @manager = @requesting_object.user.managers.find_by_avatar_key(params[:id])
          return if @manager

          @manager = @requesting_object.user.managers
                                       .find_by_avatar_name!(
                                         CGI.unescape(params[:id])
                                       )
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
