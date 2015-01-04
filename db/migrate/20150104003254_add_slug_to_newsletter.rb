class AddSlugToNewsletter < ActiveRecord::Migration
  def change
    add_column :newsletters, :slug, :string

    add_index :newsletters, :slug, unique: true

    Newsletter.all.each do |newsletter|
      if newsletter.readonly?
        sent_at = newsletter.sent_at
        newsletter.update_columns(sent_at: nil)
        newsletter.update_attributes(sent_at: sent_at)
      else
        newsletter.save
      end
    end
  end
end
