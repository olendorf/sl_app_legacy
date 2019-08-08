class Api::V1::Listable::AvatarsController < Api::V1::ApiController
  
  skip_before_action :load_requesting_object, except: [:create]
  prepend_before_action :load_requesting_object
  
  def create
    authorize Listable::Avatar
    @requesting_object.user.managers << Listable::Avatar.create!(atts)
    render json: { message: 'Created'}, status: :created
  end
  
  def index
    authorize Listable::Avatar
    params['page'] ||= 1
    pages = @requesting_object.user.managers.page(params['page']).per(9)
    data = {
      avatars: pages.map { |a| a.avatar_name },
      total_pages: pages.total_pages,
      current_page: pages.current_page,
      next_page: pages.next_page,
      prev_page: pages.prev_page
    }
    
    render json: { 
                    message: 'OK',
                    data: data
                  },
            status: :ok
  end 
  
  def destroy
    @listed_avatar = @requesting_object.user.managers.
                        find_by_avatar_name!(CGI.unescape(params[:id]))
    authorize @listed_avatar
    @listed_avatar.destroy!
    render json: {
      message: I18n.t("api.listable.avatar.destroy.success")
    }
  end

  def atts
    JSON.parse(request.raw_post)
  end
  
  def api_key
    @requesting_object.api_key
  end
end
