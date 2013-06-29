class Feed < ActiveRecord::Base

  has_many :stories, -> { order 'published DESC' }
  has_many :subscriptions
end
