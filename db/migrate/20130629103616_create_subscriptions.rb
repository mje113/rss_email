class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :feed
      t.timestamps
    end

    add_index :subscriptions, :user_id
    add_index :subscriptions, :feed_id
  end
end
