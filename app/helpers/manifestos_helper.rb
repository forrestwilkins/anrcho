module ManifestosHelper
  def current_manifesto
    @manifesto = Manifesto.where(ratified: true).last
  end
end
