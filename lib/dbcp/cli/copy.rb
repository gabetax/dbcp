module Dbcp
  class Cli::Copy
    def initialize(source, destination)
      @source, @destination = source, destination
    end

    def run
      export
      transfer
      import
      cleanup
    end

    private

    def export
      Dbcp.logger.info "exporting #{@source.environment_name}..."
      @source_snapshot_file = @source.export
    end

    def transfer
      Dbcp.logger.info "transferring data..."
      @destination_snapshot_file = @source_snapshot_file.transfer_to(@destination)
    end

    def import
      Dbcp.logger.info "importing #{@destination_snapshot_file.path} to #{@destination.environment_name}..."
      @destination.import @destination_snapshot_file
    end

    def cleanup
      if @source_snapshot_file != @destination_snapshot_file
        Dbcp.logger.info "cleaning up DB snapshots..."
        @source_snapshot_file.delete
        @destination_snapshot_file.delete
      end
    end
  end
end
