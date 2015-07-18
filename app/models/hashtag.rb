class Hashtag < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :comment
  belongs_to :group
  
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
