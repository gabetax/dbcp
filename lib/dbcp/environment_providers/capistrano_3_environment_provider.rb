begin
  # Capistrano 3 is built on rake. Capistrano 2 has a totally different API
  gem 'capistrano', '~> 3.0'
  require 'capistrano/all'

  module Dbcp
    class Capistrano3EnvironmentProvider
      REMOTE_YAML_PATH = 'config/database.yml'

      # @return [Environment, nil]
      def find(environment_name)
        task = capistrano_application.lookup environment_name
        if task
          build_environment environment_name, task
        end
      end

      private

      # Capistrano and rake both use a lot of global state. `load_rakefile`
      # loads _ONLY_ to the global `Rake.application` instance. If you load
      # the Capfile twice, the second time comes back empty.
      def capistrano_application
        @@capistrano_application ||= load_capistrano_application
      end

      def load_capistrano_application
        original_application = Rake.application

        Rake.application = Capistrano::Application.new
        Rake.application.init
        Rake.application.load_rakefile

        Rake.application
      end


      def build_environment(environment_name, task)
        execution_host = execution_host_from_task task
        Environment.new({
          environment_name: environment_name,
          database:         execution_host.remote_database('current/config/database.yml', environment_name),
          execution_host:   execution_host
        })
      end

      def execution_host_from_task(task)
        task.invoke
        cap_env = Capistrano::Configuration.env
        server  = Capistrano::Configuration.env.primary(:db)

        SshExecutionHost.new({
          host:     server.hostname,
          port:     server.port,
          username: server.user,
          path:     cap_env.fetch(:deploy_to)
        })
      end
    end
  end

rescue LoadError
  # Class won't exist. Make sure to check `if defined?(Dbcp::CapistranoEnvironmentProvider)`
end
