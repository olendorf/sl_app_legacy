class Analyzable::TransactionDecorator < ApplicationDecorator
  delegate_all
  include Rails.application.routes.url_helpers
  
  def source_link
    if self.web_object
      slug = self.web_object.actable.nil? ? 'rezzable_web_object' : self.web_object.actable.class.name.underscore.gsub('/', '_')
      h.link_to self.web_object.object_name, send("admin_#{slug}_path", self.web_object)
    else
      'Web Generated'
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
