require 'spec_helper'

describe Dbcp::Environment do

  describe ".find" do
    context "when not found" do
      specify { expect { Dbcp::Environment.find 'does-not-exist' }.to raise_error(Dbcp::EnvironmentNotFound) }
    end

    context "when found" do
      let(:environment) { double }
      before { allow_any_instance_of(Dbcp::DatabaseYamlEnvironmentProvider).to receive(:find).and_return(environment) }
      specify { expect(Dbcp::Environment.find 'development').to eq environment }
    end
  end


  describe "import/export" do
    subject { Dbcp::Environment.new database: database, execution_host: execution_host }
    let(:database) { double 'Dbcp::Database', export_command: double, import_command: double }
    let(:execution_host) { double 'Dbcp::ExecutionHost', execute: nil }
    # before { allow(Kernel).to receive(:system) }

    describe "#export" do
      it "executes the database's export command" do
        subject.export
        expect(subject.execution_host).to have_received(:execute).with(database.export_command)
      end

      it "returns the snapshot file" do
        expect(subject.export).to be_a Dbcp::DatabaseSnapshotFile
      end
    end

    describe "#import" do
      let(:snapshot_file) { double }
      it "executes the database's import command" do
        subject.import snapshot_file
        expect(subject.execution_host).to have_received(:execute).with(database.import_command)
      end
    end
  end


end
