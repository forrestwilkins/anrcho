module TokenHelper
  def awesome_colors char, chars
    multiplier = 2
    # gets the two characters after the current one
		next_char = chars[chars.index(char) + 1]
    next_char = chars[chars.index(char) - 1] if next_char.nil?
		after_next = chars[chars.index(next_char) + 1]
    after_next = chars[chars.index(next_char) - 1] if after_next.nil?
    
    # converts to percentages for each
    char_per = char.codepoints.last * 0.01
    next_char_per = next_char.codepoints.last * 0.01
    after_next_per = after_next.codepoints.last * 0.01
    
    # applies multiplier to bring codes in range of color
    char_code = char.codepoints.last * multiplier
    next_char_code = next_char.codepoints.last * multiplier
    after_next_code = after_next.codepoints.last * multiplier
    
    # manipulates for contrast
    char = (char_code * char_per).to_i
    next_char = (next_char_code * next_char_per).to_i
    after_next = (after_next_code * after_next_per).to_i
    
    # returns the string of rgb values for css
    return "#{char}, #{next_char}, #{after_next}"
  end
end
