class ManifestosController < ApplicationController
  def toggle_manifesto
    @manifesto = Manifesto.last
  end
end
