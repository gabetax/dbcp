require 'spec_helper'

describe Dbcp::PostgresDatabase do
  subject do
    Dbcp::PostgresDatabase.new({
      host: 'local',
      database: 'my_database',
      username: 'my_user',
      password: 'my_password',
    })
  end

  let(:snapshot_file) { Dbcp::DatabaseSnapshotFile.new }

  describe "#export_command" do
    specify { expect(subject.export_command snapshot_file).to match 'pg_dump' }
  end

  describe "#import_command" do
    specify { expect(subject.import_command snapshot_file).to match 'pg_restore' }
  end
end
