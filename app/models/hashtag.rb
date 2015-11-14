class Hashtag < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :comment
  belongs_to :group
  belongs_to :vote
  
  def trending?
    matches = Hashtag.where tag: self.tag
    recent_matches = matches.select do |tag|
      tag.created_at < 1.week.ago
    end
    return (recent_matches.size > Hashtag.all.size / 4)
  end
  
  def self.add_from text, item
    text.split(" ").each do |tag|
      next unless tag.size > 1
      tag = "#" + tag unless tag.include? "#"
      tag.slice!(",") if tag.include? ","
      item.hashtags.create(tag: tag)
    end
  end
  
  def self.extract item
    text = item.body
    text.split(' ').each do |word|
      if word.include? "#" and word.size > 1
        item.hashtags.create(tag: word, index: text.index(word))
      end
    end
  end
end
