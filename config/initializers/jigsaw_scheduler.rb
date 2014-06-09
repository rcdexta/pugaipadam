require 'rufus-scheduler'
require 'rake'

scheduler = Rufus::Scheduler.new

Rake::Task.clear
PugaipadamRails4::Application.load_tasks

scheduler.cron '5 5 * * *' do
  p '*'*100
  p 'Pulling Jigsaw data...'
  Rake::Task['pugaipadam:jigsaw_sync'].reenable
  Rake::Task['pugaipadam:jigsaw_sync'].invoke
  p 'Done!'
  p '*'*100
end
