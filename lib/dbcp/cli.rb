module Dbcp
  class Cli
    require 'dbcp/cli/copy'
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

      Copy.new(source, destination).run
    end

  end
end
