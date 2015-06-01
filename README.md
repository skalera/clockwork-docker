# clockwork-docker

Invoke with:

  docker run -e 'DATABASE_URL=sqlite://foo.db' skalera/clockwork

if `DATABASE_URL` is left out, it will try to connect to consul and use postgres.

To trigger sidekiq jobs, just add a new entry in the database. E.g. will trigger `FooWorker.perform_async` every
hour.

  hour = FrequencyPeriod.find(name: 'hour')
  ClockworkDatabaseEvent.create(frequency_period: hour, name: 'FooWorker')
