class ManifestosController < ApplicationController
  def toggle_manifesto
    @manifesto = Manifesto.last
  end
  
  def index
    @manifestos = Manifesto.proposed
  end
end
