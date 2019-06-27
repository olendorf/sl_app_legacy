
module ActiveAdmin
  module RezzableBehavior
    extend ActiveSupport::Concern
    
    def self.included(base)
      
      base.before_destroy do |resource|
        derez_web_object(resource)
      end
      
      base.before_update do |resource|
        update_web_object(resource)
      end
    
      base.controller do 
        def derez_web_object(resource)
          auth_time = Time.now.to_i
          auth_digest = Digest::SHA1.hexdigest(auth_time.to_s + resource.rezzable.api_key)
          RestClient.delete resource.url, 
                           {
                             content_type: :json, 
                             accept: :json, 
                             'x-auth-digest' => auth_digest,
                             'x-auth-time' => auth_time
                           }
          
        end
        
        def update_web_object(resource)
          auth_time = Time.now.to_i
          auth_digest = Digest::SHA1.hexdigest(auth_time.to_s + resource.rezzable.api_key)
          params['rezzable_terminal'].each do |att, val|
            RestClient.put  resource.url,
                            {att => val}.to_json,
                            {
                              content_type: :json, 
                              accept: :json, 
                              'x-auth-digest' => auth_digest,
                              'x-auth-time' => auth_time
                            }
          end
          
        end
      end
    end
  end 
end