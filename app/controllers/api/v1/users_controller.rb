class Api::V1::UsersController < Api::V1::ApiController
  def create
    authorize User
    @user = User.new(JSON.parse(request.raw_post))
    @user.save!
    render json: {message: 'Created'}, status: :created
  end
  
  def show 
    load_record
    authorize @user 
    data = @user.attributes.slice('avatar_key', 'avatar_name', 'role', 'object_weight', 'account_level', 'expiration_date')
    render json: {message: 'OK', data: data}
  end
  
  private
  
  def load_record
    @user = User.find_by_avatar_key! params[:id]
  end
end
