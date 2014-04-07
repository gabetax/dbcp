module Dbcp
  class DatabaseSnapshotFile
    attr_reader :path
    attr_reader :environment

    def initialize(environment)
      @environment = environment
      @path = "/tmp/dbcp_#{Time.now.to_f}"
    end

    # @return [DatabaseSnapshotFile]
    def transfer_to(destination_environment)
      source_host      = environment.execution_host
      destination_host = destination_environment.execution_host

      return self if source_host.local? && destination_host.local?
      return self if source_host == destination_host

      destination_snapshot_file = DatabaseSnapshotFile.new(destination_environment)

      if source_host.local? && destination_host.remote?
        destination_host.upload path, destination_snapshot_file.path

      elsif source_host.remote? && destination_host.local?
        source_host.download path, destination_snapshot_file.path

      else
        # both remote
        source_host.download path, path
        destination_host.upload path, destination_snapshot_file.path
      end

      destination_snapshot_file
    end

    def delete
      environment.execution_host.execute %W(rm #{path}).shelljoin
    end
  end
end
