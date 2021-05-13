Application.configure do |app|
  logdev = Application.environment == :production ? STDOUT : app.root.concat('/', Settings.logger.path)

  logger = Ougai::Logger.new(
    logdev,
    level: Settings.logger.level
  )

  if Application.environment == :development
    logger.formatter = Ougai::Formatters::Readable.new
  end

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
    data[:request_id] = Thread.current[:request_id]
  end

  app.set :logger, logger
end

Sequel::Model.db.loggers.push(Application.logger)
