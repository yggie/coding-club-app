namespace :newsletter do
  task 'create-draft' => [ :environment ] do
    @target_date = ENV['DRAFT_TARGET_DATE']
    raise 'Must specify DRAFT_TARGET_DATE to run task' unless @target_date

    parsed_date = DateTime.parse(@target_date).strftime('%Y-%m-%d')
    CreateNewsletterDraftJob.new.perform(parsed_date)
    puts "Successfully created newsletter for #{parsed_date}!"
  end
end
