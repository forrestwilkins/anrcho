class ManifestosController < ApplicationController
  def index
    @manifesto = Manifesto.last
  end
end
