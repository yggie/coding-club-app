class RemoveNewslettersUsersRelationship < ActiveRecord::Migration
  def change
    remove_column :newsletters, :user_id
  end
end
