class Api::V1::Analyzable::TransactionsController < Api::V1::ApiController
  
  skip_before_action :load_requesting_object, except: [:create]
  prepend_before_action :load_requesting_object
  
  def create
    authorize Analyzable::Transaction
    @transaction = Analyzable::Transaction.new(JSON.parse(request.raw_post))
    @requesting_object.user.transactions << @transaction
    handle_splits if JSON.parse(request.raw_post)['amount'] > 0
    render json: {message: 'CREATED'}, status: :created
  end
  
  private
  
  def handle_splits
    splits = @requesting_object.user.splits
    if @requesting_object.actable && @requesting_object.actable.respond_to?(:splits)
      splits = splits + @requesting_object.actable.splits 
    end
    splits.each do |split|
      transaction = Analyzable::Transaction.new(
        amount: -1 * JSON.parse(request.raw_post)['amount'] * split.percent,
        category: :share,
        description: "Split from transaction ##{@transaction.id}",
        rezzable_id: @requesting_object.id,
        target_name: split.target_name,
        target_key: split.target_key
        )
      @requesting_object.user.transactions << transaction  
      @transaction.sub_transactions << transaction
    end
  end
  
  def api_key
    @requesting_object.api_key
  end
end
