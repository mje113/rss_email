class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string     :title
      t.string     :entry_id
      t.string     :permalink
      t.text       :body
      t.datetime   :published
      t.string     :author
      t.references :feed
      t.timestamps
    end

    add_index :stories, :feed_id
    add_index :stories, [:permalink, :feed_id], unique: true
  end
end
