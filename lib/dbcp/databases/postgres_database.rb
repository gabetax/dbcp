module Dbcp
  class PostgresDatabase < Database
    def export_command(snapshot_file)
      %W[export PGPASSWORD=#{password}].shelljoin + '; ' + %W[pg_dump --host #{host} --username #{username} --file #{snapshot_file.path} --format c #{database}].shelljoin
    end

    def import_command(snapshot_file)
      %W[export PGPASSWORD=#{password}].shelljoin + '; ' + %W[pg_restore --host #{host} --username #{username} --clean --dbname #{database} #{snapshot_file.path}].shelljoin
    end
  end
end
