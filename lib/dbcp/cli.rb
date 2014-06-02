module Dbcp
  class Cli

    DEFAULT_DESTINATION = 'development'

    def initialize(stdout = $stdout)
      @logger = Logger.new stdout
      @logger.formatter = Proc.new do |severity, datetime, progname, msg|
        "#{datetime}: #{msg}\n"
      end
    end

    def start(argv, opts=[])

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
      source_snapshot_file = source.export

      @logger.info "transferring data..."
      destination_snapshot_file = source_snapshot_file.transfer_to(destination)

      @logger.info "importing #{destination_snapshot_file.path} to #{destination.environment_name}..."
      destination.import destination_snapshot_file

      source_snapshot_file.delete
      destination_snapshot_file.delete if source_snapshot_file != destination_snapshot_file
    end

  end
end
