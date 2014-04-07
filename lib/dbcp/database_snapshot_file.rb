module Dbcp
  class DatabaseSnapshotFile
    attr_reader :path
    attr_reader :environment

    def initialize(environment)
      @environment = environment
      @path = "/tmp/dbcp_#{Time.now.to_f}"
    end
  end
end
