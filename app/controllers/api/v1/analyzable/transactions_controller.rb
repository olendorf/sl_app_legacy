class Api::V1::Analyzable::TransactionsController < Api::V1::ApiController
  
  skip_before_action :load_requesting_object, except: [:create]
  prepend_before_action :load_requesting_object
  
  def create
    authorize Analyzable::Transaction
    @transaction = Analyzable::Transaction.new(transaction_params)
    @requesting_object.user.transactions << @transaction
    render json: {message: 'CREATED'}, status: :created
  end
  
  private
  
  def transaction_params
    params.permit(:amount, :description, :target_key, :target_name)
  end
  
  def api_key
    @requesting_object.api_key
  end
end
