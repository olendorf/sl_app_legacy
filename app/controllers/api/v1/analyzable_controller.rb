class Api::V1::AnalyzableController < Api::V1::ApiController
  
  skip_before_action :load_requesting_object, except: [:create]
  prepend_before_action :load_requesting_object
end
