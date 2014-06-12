module Dbcp
  class Log

    class << self

      def silent
        log('/dev/null')
      end

      def stdout
        log($stdout)
      end

      private

      def log(location)
        Logger.new(location).tap do |l|
          l.formatter = Proc.new do |severity, datetime, progname, msg|
            "#{datetime}: #{msg}\n"
          end
        end
      end

    end

  end
end
