module ApplicationHelper
	def random_color
		rgb = []; 3.times { rgb << Random.rand(1..255) }
		return rgb
	end
end
