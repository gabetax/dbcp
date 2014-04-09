require 'net/ssh'
require 'net/sftp'
require 'uri'

module Dbcp
  class SshExecutionHost < ExecutionHost

    class << self
      def new_from_uri(uri_string)
        uri = URI.parse uri_string
        raise URI::InvalidURIError.new "SSH URI must be in form 'ssh://username@example.com/path/to_application_root'. We received: '#{uri_string}'." unless uri.user && uri.host
        new({
          host:     uri.host,
          port:     uri.port,
          username: uri.user,
          path:     uri.path
        })
      end
    end

    values do
      attribute :host
      attribute :port, Fixnum
      attribute :username
      attribute :path
    end

    def remote?
      true
    end

    def execute(command)
      # http://stackoverflow.com/questions/3386233/how-to-get-exit-status-with-rubys-netssh-library
      stdout_data = ""
      stderr_data = ""
      exitstatus  = nil
      exit_signal = nil

      Net::SSH.start host, username do |ssh|
        ssh.open_channel do |channel|
          channel.exec command do |ch, success|
            unless success
              raise ExecutionError.new "Exection over SSH to failed for: (ssh.channel.exec)"
            end
            channel.on_data do |ch,data|
              stdout_data+=data
            end

            channel.on_extended_data do |ch,type,data|
              stderr_data+=data
            end

            channel.on_request("exit-status") do |ch,data|
              exitstatus = data.read_long
            end

            channel.on_request("exit-signal") do |ch, data|
              exit_signal = data.read_long
            end
          end
        end
        ssh.loop
      end

      raise ExecutionError.new "Execution failed with exit code #{$?.exitstatus}. Command was: #{command}" if exitstatus > 0
    end

    # Omitting destination_path will return file contents as a string
    def download(source_path, destination_path = nil)
      Net::SFTP.start host, username do |ssh|
        return ssh.download! source_path, destination_path
      end
    end

    def upload(source_path, destination_path)
      Net::SFTP.start host, username do |ssh|
        return ssh.upload! source_path, destination_path
      end
    end
  end
end
