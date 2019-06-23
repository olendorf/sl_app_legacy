# frozen_string_literal: true

# rubocop:disable Style/StructInheritance
# have to do this as per pundit documentaitons
# Headless policy for static pages
class StaticPagePolicy < Struct.new(:user, :static_page)
  def home?
    true
  end
end

# rubocop:enable Style/StructInheritance
