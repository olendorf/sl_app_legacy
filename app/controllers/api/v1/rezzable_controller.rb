module Api
  module V1
    # Common controller functionality for rezzables
    class RezzableController < Api::V1::ApiController
      
      private

      def pundit_user
        # @requesting_object&.user
        User.find_by_avatar_key!(request.headers['HTTP_X_SECONDLIFE_OWNER_KEY'])
      end
    end 
  end 
end
