class RawStory
  attr_accessor :id, :published, :updated, :permalink, :body, :author

  def initialize(feedzirra_entry)
    @id        = feedzirra_entry.entry_id
    @published = feedzirra_entry.published
    @updated   = feedzirra_entry.updated
    @permalink = feedzirra_entry.url
    @body      = feedzirra_entry.content
    @author    = feedzirra_entry.author
  end
end
