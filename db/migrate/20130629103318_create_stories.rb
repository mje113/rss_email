class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string     :title
      t.string     :permalink
      t.text       :body
      t.datetime   :published
      t.string     :author
      t.references :feed
      t.timestamps
    end
  end
end
