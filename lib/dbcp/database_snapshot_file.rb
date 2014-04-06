module Dbcp
  class DatabaseSnapshotFile
    attr_reader :path

    def initialize
      @path = "/tmp/dbcp_#{Time.now.to_f}"
    end
  end
end
