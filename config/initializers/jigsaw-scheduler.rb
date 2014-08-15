require 'rufus-scheduler'
require 'rake'

scheduler = Rufus::Scheduler.new

Rake::Task.clear
PugaipadamRails4::Application.load_tasks

scheduler.cron '0 7 * * 1-5' do
  Rails.logger.warn '*'*100
  Rails.logger.warn 'Pulling Jigsaw data...'
  Rake::Task['pugaipadam:jigsaw_sync'].reenable
  Rake::Task['pugaipadam:jigsaw_sync'].invoke
  Rails.logger.warn 'Done!'
  Rails.logger.warn '*'*100
end