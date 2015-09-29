module BannersHelper
  def current_banner group
    if group.banners.present?
      group.banners.last.image
    else
      nil
    end
  end
end
