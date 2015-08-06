class ManifestosController < ApplicationController
  def toggle_manifesto
    @manifesto = Manifesto.last
  end
  
  def index
    @manifestos_index = true
    @manifestos = Manifesto.proposed
  end
  
  def create
    @manifesto = Manifesto.new(params[:manifesto].permit(:body))
    @manifesto.save if @manifesto.body.present?; redirect_to :back
  end
end