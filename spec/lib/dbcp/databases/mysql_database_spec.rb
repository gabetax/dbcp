require 'spec_helper'

describe Dbcp::MysqlDatabase do
  subject do
    Dbcp::MysqlDatabase.new({
      host: 'local',
      database: 'my_database',
      username: 'my_user',
      password: 'my_password',
    })
  end

  let(:snapshot_file) { Dbcp::DatabaseSnapshotFile.new double }

  describe "#export_command" do
    specify { expect(subject.export_command snapshot_file).to match 'mysqldump' }
  end

  describe "#import_command" do
    specify { expect(subject.import_command snapshot_file).to match 'mysql' }
  end
end
