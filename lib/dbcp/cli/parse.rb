module Dbcp
  class Cli::Parse

    require 'slop'

    def self.run(argv)

      opts = Slop.parse(argv, help: true) do
        banner "Usage: #{$0} source_environment [destination_environment || #{Dbcp::Cli::DEFAULT_DESTINATION}]"

        on :v, :version, 'Print the Version' do
          puts "dbcp #{Dbcp::VERSION}"
          exit
        end

        run do |opts, args|
          if args.empty?
            puts help
            exit 1
          else
            Dbcp::Cli.start(args, opts)
          end
        end
      end
    end

  end
end
