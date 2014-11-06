class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :subject, null: false
      t.text :body, null: false
      t.references :user, null: false

      t.datetime :sent_at
      t.timestamps
    end
  end
end
