module Dbcp
  class LocalExecutionHost < ExecutionHost

    # Cheap way for == to evaluate to `true` between `LocalExecutionHost` objects
    values do
    end

    def remote?
      false
    end

    def execute(command)
      Kernel.system command
      raise ExecutionError.new "Execution failed with exit code #{$?.exitstatus}. Command was: #{command}" unless $?.success?
    end
  end
end
