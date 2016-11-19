module ManifestosHelper
  def current_manifesto
    @manifesto = Manifesto.where(group_token: [nil, ""]).last
  end
end
