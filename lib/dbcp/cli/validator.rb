module Dbcp
  class Cli::Validator

    def initialize(source, destination)
      @source, @destination = source, destination
    end

    def run
      if @source == @destination
        Dbcp.logger.fatal "source and destination environments are the same"
        exit 3
      end

      if @source.database.adapter != @destination.database.adapter
        Dbcp.logger.fatal "source (#{@source.database.adapter}) and destination (#{@destination.database.adapter}) environments must be the same database type"
        exit 4
      end
    end
  end
end
