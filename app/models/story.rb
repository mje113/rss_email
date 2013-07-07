class Story < ActiveRecord::Base

  belongs_to :feed

  validates :entry_id,  uniqueness: { scope: :feed_id }
  validates :permalink, uniqueness: { scope: :feed_id }

  def self.create_from_raw(raw_story)
    create(
      title:     raw_story.title,
      entry_id:  raw_story.id,
      published: raw_story.published,
      permalink: raw_story.permalink,
      body:      raw_story.body,
      author:    raw_story.author
    )
  end
end
