module Dbcp
  class EnvironmentNotFound < StandardError; end
  class ExecutionError      < StandardError; end

  class Environment
    ENVIRONMENT_PROVIDERS = [
      DatabaseYamlEnvironmentProvider.new('config/database.yml')
    ]

    class << self
      def find(environment_name)
        ENVIRONMENT_PROVIDERS.each do |provider|
          environment = provider.find environment_name
          return environment if environment
        end

        raise EnvironmentNotFound.new "Could not locate '#{environment_name}' environment"
      end
    end

    # coersion causes issues when assigning rspec doubles
    include Virtus.value_object(coerce: false)
    values do
      attribute :environment_name, String
      attribute :database,         Database
    end

    def export
      DatabaseSnapshotFile.new.tap do |snapshot_file|
        execute database.export_command(snapshot_file)
      end
    end

    def import(snapshot_file)
      execute database.import_command(snapshot_file)
    end

    private

    def execute(command)
      Kernel.system command
      raise ExecutionError.new "Execution failed with exit code #{$?.exitstatus}. Command was: #{command}" unless $?.success?
    end
  end

end
