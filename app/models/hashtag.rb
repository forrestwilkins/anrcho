class Hashtag < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :comment
  belongs_to :group
  
  def self.extract(item)
    text = item.body
    text.split(' ').each do |word|
      if word.include? "#" and word.size > 1
        item.hashtags.create(tag: word, index: text.index(word))
      end
    end
  end
end
