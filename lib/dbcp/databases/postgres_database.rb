module Dbcp
  class PostgresDatabase < Database
    def export_command(snapshot_file)
      build_password + [
        'pg_dump',
        '--host',     host,
        build_port,
        '--username', username,
        '--file',     snapshot_file.path,
        '--format',   'c',
        database
      ].flatten.compact.shelljoin
    end

    def import_command(snapshot_file)
      build_password + [
        'pg_restore',
        '--host',     host,
        build_port,
        '--username', username,
        '--dbname',   database,
        '--clean',
        snapshot_file.path
      ].flatten.compact.shelljoin
    end

    private

    def build_password
      %W[export PGPASSWORD=#{password}].shelljoin + '; '
    end

    def build_port
      ['--port', port] if host && port
    end

  end
end
