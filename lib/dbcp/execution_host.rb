module Dbcp
  class ExecutionHost
    class << self
      def build(args)
        if args['ssh_uri']
          SshExecutionHost.new_from_uri args['ssh_uri']
        else
          LocalExecutionHost.new
        end
      end
    end

  # coersion causes issues when assigning rspec doubles
  include Virtus.value_object(coerce: false)

  def local?
    !remote?
  end

  end
end
