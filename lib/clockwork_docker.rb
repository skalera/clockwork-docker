require 'logger'
require 'sequel'
require 'clockwork'
require 'clockwork/database_events'
require 'clockwork_database_events/models'

module Clockwork
  logger = Logger.new(ENV['LOGGER'] || STDOUT)

  # required to enable database syncing support
  Clockwork.manager = DatabaseEvents::Manager.new
  ClockworkDatabaseEvents.seed

  sync_database_events(model: ClockworkDatabaseEvent, every: 1.minute) do |model|
    if model.name
      logger.info("scheduling sidekiq job for #{model.name}")
      Sidekiq::Client.push('class' => model.name)
    else
      logger.warn('no class name provided')
    end
  end
end
