module BannersHelper
  def current_banner
    Banner.last
  end
end
