# frozen_string_literal: true

module Api
  module V1
    # Common controller functionality for rezzables
    # In most cases there should be no need to implement the basic CRUD methods
    # (create, show, update,destroy). Inheriting classes should just implement the
    # response_data method.
    class RezzableController < Api::V1::ApiController
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def create
        if ::Rezzable::WebObject.find_by_object_key atts[:object_key]
          load_requesting_object
          update
        else
          authorize requesting_class
          @web_object = requesting_class.new(atts)
          @web_object.save!
          pundit_user.web_objects << @web_object
          render json: {
            message: I18n.t("api.rezzable.#{controller_name.singularize}.create.success"),
            data: { api_key: @web_object.api_key }
          }, status: :created
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def show
        authorize @requesting_object
        render json: { message: 'OK', data: response_data }
      end

      def update
        authorize @requesting_object, :update?
        @requesting_object.update!(atts)
        render json: {
          message: I18n.t("api.rezzable.#{controller_name.singularize}.update.success")
        }
      end

      def destroy
        authorize @requesting_object
        @requesting_object.destroy!
        render json: {
          message: I18n.t("api.rezzable.#{controller_name.singularize}.destroy.success")
        }
      end

      private

      ## Inheriting classes should implement this calls to return
      ## a hash with the relevant data.
      # def response_data
      #   ...
      # end

      def requesting_class
        "::Rezzable::#{controller_name.classify}".constantize
      end

      # rubocop:disable Metrics/AbcSize
      def atts
        {
          object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY'],
          object_name: request.headers['HTTP_X_SECONDLIFE_OBJECT_NAME'],
          region: extract_region_name,
          position: format_position,
          user_id: User.find_by_avatar_key(
            request.headers['HTTP_X_SECONDLIFE_OWNER_KEY']
          )
        }.merge(JSON.parse(request.raw_post))
      end

      # rubocop:enable Metrics/AbcSize

      def extract_region_name
        region_regex = /(?<name>[a-zA-Z0-9 ]+) ?\(?/
        matches = request.headers['HTTP_X_SECONDLIFE_REGION'].match(region_regex)
        matches[:name]
      end

      def format_position
        pos_regex = /\((?<x>[0-9\.]+), (?<y>[0-9\.]+), (?<z>[0-9\.]+)\)/
        matches = request.headers['HTTP_X_SECONDLIFE_LOCAL_POSITION'].match(pos_regex)
        { x: matches[:x].to_f, y: matches[:y].to_f, z: matches[:z].to_f }.to_json
      end

      def pundit_user
        # @requesting_object&.user
        User.find_by_avatar_key!(request.headers['HTTP_X_SECONDLIFE_OWNER_KEY'])
      end
    end
  end
end
