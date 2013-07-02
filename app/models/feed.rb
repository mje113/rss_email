class Feed < ActiveRecord::Base

  has_many :stories, -> { order 'published DESC' }
  has_many :subscriptions

  validates :url, uniqueness: true
end
