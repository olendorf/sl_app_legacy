module Api
  module V1
    module Rezzable
      # Controller for terminal requests .
      class TerminalsController < Api::V1::RezzableController
        
        def create
          authorize ::Rezzable::Terminal
          @web_object = ::Rezzable::Terminal.new(atts)
          @web_object.save!
          render json: {
            message: I18n.t('api.rezzable.terminal.create.success'), 
            data: {api_key: @web_object.api_key}
          }, status: :created
        end
        
        def show
          authorize @requesting_object
          render json: {message: 'OK', data: {updated_at: @requesting_object.updated_at.to_s(:long)}}
        end
        
        def update 
          authorize @requesting_object
          @requesting_object.update!(atts)
          render json: {message: I18n.t('api.rezzable.terminal.update.success') }
        end
        
        def destroy
          authorize @requesting_object
          @requesting_object.destroy!
          render json: { message: I18n.t('api.rezzable.terminal.destroy.success') }
        end
        
        def atts
          {
            object_key: request.headers['HTTP_X_SECONDLIFE_OBJECT_KEY'],
            object_name: request.headers['HTTP_X_SECONDLIFE_OBJECT_NAME'],
            region: request.headers['HTTP_X_SECONDLIFE_REGION'],
            position: request.headers['HTTP_X_SECONDLIFE_LOCAL_POSITION'],
            user_id: User.find_by_avatar_key(request.headers['HTTP_X_SECONDLIFE_OWNER_KEY'])
          }.merge(JSON.parse(request.raw_post))
        end
        
      end 
    end 
  end 
end
