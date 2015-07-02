module ManifestosHelper
  def current_manifesto
    @manifesto = Manifesto.last
  end
end
