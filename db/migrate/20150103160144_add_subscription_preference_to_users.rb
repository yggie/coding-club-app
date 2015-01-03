class AddSubscriptionPreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_preference, :integer, default: 1
  end
end
