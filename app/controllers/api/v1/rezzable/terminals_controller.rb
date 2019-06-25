module Api
  module V1
    module Rezzable
      # Controller for terminal requests .
      class TerminalsController < Api::V1::RezzableController
        
        # def create
        #   authorize ::Rezzable::Terminal
        #   @web_object = ::Rezzable::Terminal.new(atts)
        #   @web_object.save!
        #   render json: {
        #     message: I18n.t('api.rezzable.terminal.create.success'), 
        #     data: {api_key: @web_object.api_key}
        #   }, status: :created
        # end
        
        # def show
        #   authorize @requesting_object
        #   render json: {message: 'OK', data: {updated_at: @requesting_object.updated_at.to_s(:long)}}
        # end
        
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
        
        private 
        
        def response_data
          {updated_at: @requesting_object.updated_at.to_s(:long)}
        end
        

        
      end 
    end 
  end 
end
