class Api::V1::UsersController < Api::V1::ApiController
  def create
    authorize User
    render json: {message: 'Created'}, status: :created
  end
end
