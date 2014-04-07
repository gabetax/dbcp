module Dbcp
  class MysqlDatabase < Database
    def export_command(snapshot_file)
      %W[mysqldump #{socket_or_host} --user=#{username} --password=#{password} --add-drop-table --extended-insert --result-file=#{snapshot_file.path} #{database}].shelljoin
    end

    def import_command(snapshot_file)
      %W[mysql #{socket_or_host} --user=#{username} --password=#{password} #{database}].shelljoin + ' < ' + snapshot_file.path.shellescape
    end

    private

    def socket_or_host
      if socket
        "--socket=#{socket}"
      else
        "--host=#{host}"
      end
    end
  end
end
