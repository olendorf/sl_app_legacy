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
    render json: {message: 'OK', data: response_data}
  end
  
  def update
    load_record
    authorize @user 
    @user.update! JSON.parse(request.raw_post)
    render json: {message: I18n.t('api.user.update.success'), data: response_data}
  end
  
  def destroy
    load_record
    authorize @user
    @user.destroy!
    render json: {message: I18n.t('api.user.destroy.success')}
  end
  
  private
  
  def response_data
    @user.attributes.slice('avatar_key', 'avatar_name', 'role', 'object_weight', 'account_level', 'expiration_date')
  end
  
  def load_record
    @user = User.find_by_avatar_key! params[:id]
  end
end
