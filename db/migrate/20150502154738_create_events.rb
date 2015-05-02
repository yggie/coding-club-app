class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :technologies
      t.string :summary

      t.references :user
      t.date :date

      t.timestamps null: false
    end
  end
end
