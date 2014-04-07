module Dbcp
  class DatabaseSnapshotFile
    attr_reader :path
    attr_reader :environment

    def initialize(environment)
      @environment = environment
      @path = "/tmp/dbcp_#{Time.now.to_f}"
    end

    def delete
      environment.execute %W(rm #{path}).shelljoin
    end
  end
end
