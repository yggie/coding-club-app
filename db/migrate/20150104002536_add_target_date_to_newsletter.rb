class AddTargetDateToNewsletter < ActiveRecord::Migration
  def change
    add_column :newsletters, :target_date, :date

    Newsletter.all.each do |newsletter|
      newsletter.update_columns(target_date: newsletter.sent_at)
    end
  end
end
