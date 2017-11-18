Exchanger.logger.formatter = proc do |severity, _datetime, _progname, msg|
  "[#{severity}] #{msg}\n"
end
Exchanger.logger.level = (Exchanger.env == 'production' ? Logger::DEBUG : Logger::INFO)
