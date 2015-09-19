class ManifestosController < ApplicationController
  def toggle_manifesto
    @manifesto = Manifesto.last
    cookies.permanent[:manifesto_tip] = true
  end
  
  def index
    @manifestos_index = true
    @proposed_manifestos = Proposal.where(action: :update_manifesto)
  end
end
