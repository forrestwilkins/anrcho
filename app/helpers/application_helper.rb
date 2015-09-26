module ApplicationHelper
  def time_ago(_time_ago)
    _time_ago = _time_ago + " ago"
    if _time_ago.include? "about"
    	_time_ago.slice! "about "
    end
    if _time_ago[0].to_i > 0 and _time_ago[1].to_i > 0
      _time_ago = _time_ago[0..2] + _time_ago[3.._time_ago.size]
    elsif _time_ago[0].to_i > 0
      _time_ago = _time_ago[0..1] + _time_ago[2.._time_ago.size]
    end
    return _time_ago
  end
  
	def random_color
		rgb = []; 3.times { rgb << Random.rand(1..255) }
		return rgb
	end
end
