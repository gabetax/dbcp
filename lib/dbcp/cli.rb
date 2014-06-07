module Dbcp
  class Cli

    require 'dbcp/cli/validate'

    DEFAULT_DESTINATION = 'development'

    def self.start(argv, opts=[])

      begin
        source = Environment.find(argv.shift)
        destination = Environment.find(argv.shift || DEFAULT_DESTINATION)
        Validate.new(source, destination).run
      rescue EnvironmentNotFound => e
        Dbcp.logger.fatal e.to_s
        exit 2
      end

      Dbcp.logger.info "exporting #{source.environment_name}..."
      source_snapshot_file = source.export

      Dbcp.logger.info "transferring data..."
      destination_snapshot_file = source_snapshot_file.transfer_to(destination)

      Dbcp.logger.info "importing #{destination_snapshot_file.path} to #{destination.environment_name}..."
      destination.import destination_snapshot_file

      source_snapshot_file.delete
      destination_snapshot_file.delete if source_snapshot_file != destination_snapshot_file
    end

  end
end
