class ChuckNorrisController < ApplicationController
  before_action :set_chuck_norri, only: [:show, :edit, :update, :destroy]

  # GET /chuck_norris
  # GET /chuck_norris.json
  def index
    @chuck_norris = ChuckNorri.all
  end

  # GET /chuck_norris/1
  # GET /chuck_norris/1.json
  def show
  end

  # GET /chuck_norris/new
  def new
    @chuck_norri = ChuckNorri.new
  end

  # GET /chuck_norris/1/edit
  def edit
  end

  # POST /chuck_norris
  # POST /chuck_norris.json
  def create
    @chuck_norri = ChuckNorri.new(chuck_norri_params)

    respond_to do |format|
      if @chuck_norri.save
        format.html { redirect_to @chuck_norri, notice: 'Chuck norri was successfully created.' }
        format.json { render :show, status: :created, location: @chuck_norri }
      else
        format.html { render :new }
        format.json { render json: @chuck_norri.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chuck_norris/1
  # PATCH/PUT /chuck_norris/1.json
  def update
    respond_to do |format|
      if @chuck_norri.update(chuck_norri_params)
        format.html { redirect_to @chuck_norri, notice: 'Chuck norri was successfully updated.' }
        format.json { render :show, status: :ok, location: @chuck_norri }
      else
        format.html { render :edit }
        format.json { render json: @chuck_norri.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chuck_norris/1
  # DELETE /chuck_norris/1.json
  def destroy
    @chuck_norri.destroy
    respond_to do |format|
      format.html { redirect_to chuck_norris_url, notice: 'Chuck norri was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chuck_norri
      @chuck_norri = ChuckNorri.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chuck_norri_params
      params.require(:chuck_norri).permit(:fact, :knockouts)
    end
end
