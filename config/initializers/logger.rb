$logger = Logger.new(STDOUT)
original_formatter = Logger::Formatter.new
$logger.formatter = proc { |severity, datetime, progname, msg|
  "\n#{original_formatter.call(severity, datetime, progname, msg)}"
}