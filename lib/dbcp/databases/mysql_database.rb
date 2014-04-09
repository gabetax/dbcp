module Dbcp
  class MysqlDatabase < Database
    def export_command(snapshot_file)
      %W[mysqldump #{build_socket_or_host} #{build_port} --user=#{username} --password=#{password} --add-drop-table --extended-insert --result-file=#{snapshot_file.path} #{database}].reject(&:empty?).shelljoin
    end

    def import_command(snapshot_file)
      %W[mysql #{build_socket_or_host} #{build_port} --user=#{username} --password=#{password} #{database}].reject(&:empty?).shelljoin + ' < ' + snapshot_file.path.shellescape
    end

    private

    def build_socket_or_host
      if socket
        "--socket=#{socket}"
      else
        "--host=#{host}"
      end
    end

    def build_port
      "--port=#{port}" if host && port
    end
  end
end
