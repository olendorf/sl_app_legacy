class Api::V1::Analyzable::InventoriesController < Api::V1::AnalyzableController
  
  def create 
    authorize @requesting_object.user
    begin
      @inventory = @requesting_object.actable.inventories.
                           find_by_inventory_name! atts['inventory_name']
      update
    rescue
      @requesting_object.actable.inventories << Analyzable::Inventory.create!(atts)
      render json: {message: 'Created'}, status: :created
    end
      
      
  end
  
  def show
    authorize @requesting_object.user
    load_inventory
    render json: {message: 'OK', data: {created_at: @inventory.created_at.to_s(:long) }}
  end 
  
  def update
    authorize @requesting_object.user 
    load_inventory unless @inventory
    render json: {message: 'OK'}
  end
  
  def destroy
    authorize @requesting_object.user
    if params['id'] == 'all'
      @requesting_object.actable.inventories.destroy_all
    else
      load_inventory
      @inventory.destroy!
    end
    render json: { message: 'OK' }
  end
  
  private
  
  def atts
    JSON.parse(request.raw_post)
  end
  
  def api_key
    @requesting_object.api_key
  end
  
  def load_inventory
    @inventory = @requesting_object.actable.inventories.
                 find_by_inventory_name! params['id']
  end
end
