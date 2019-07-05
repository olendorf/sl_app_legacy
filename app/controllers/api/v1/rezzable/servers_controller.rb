class Api::V1::Rezzable::ServersController < Api::V1::RezzableController
  
  private
  
  def response_data
    {api_key: @requesting_object.api_key}
  end 
end
