module Dbcp
  class Cli
    DEFAULT_DESTINATION = 'development'

    def initialize(stdout = $stdout)
      @logger = Logger.new stdout
      @logger.formatter = Proc.new do |severity, datetime, progname, msg|
        "#{datetime}: #{msg}\n"
      end
    end

    def start(argv)
      if argv.length < 1
        usage
        exit 1
      end

      begin
        source = Environment.find(argv.shift)
        destination = Environment.find(argv.shift || DEFAULT_DESTINATION)

        if source == destination
          @logger.fatal "source and destination environments are the same"
          exit 3
        end

        if source.database.adapter != destination.database.adapter
          @logger.fatal "source (#{source.database.adapter}) and destination (#{destination.database.adapter}) environments must be the same database type"
          exit 4
        end
      rescue EnvironmentNotFound => e
        @logger.fatal e.to_s
        exit 2
      end

      @logger.info "exporting #{source.environment_name}..."
      snapshot_file = source.export
      @logger.info "importing #{snapshot_file.path} to #{destination.environment_name}..."
      destination.import snapshot_file
      snapshot_file.delete
    end

    def usage
      @logger.fatal "Usage: #{$0} source_environment [destination_environment || #{DEFAULT_DESTINATION}]"
    end
  end
end
