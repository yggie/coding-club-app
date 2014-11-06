class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :email, null: false
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :profile_image_url

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
