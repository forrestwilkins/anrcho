class ManifestosController < ApplicationController
  def toggle_manifesto
    @manifesto = Manifesto.last
    cookies.permanent[:manifesto_tip] = true
  end
  
  def index
    @manifestos_index = true
    @proposed_manifestos = Proposal.where(action: :update_manifesto)
  end
  
  def create
    @manifesto = Manifesto.new(params[:manifesto].permit(:body))
    @manifesto.save if @manifesto.body.present?; redirect_to :back
  end
end
