class StaticPagePolicy < Struct.new(:user, :static_page)
  
  def home?
    true
  end

end
