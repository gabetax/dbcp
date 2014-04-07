require 'spec_helper'

describe Dbcp::DatabaseSnapshotFile do
  subject { Dbcp::DatabaseSnapshotFile.new environment }
  let(:environment) { double 'Dbcp::Environment', execution_host: execution_host }
  let(:execution_host) { double 'Dbcp::ExecutionError' }

  describe "#path" do
    it "defines a temporary path" do
      expect(subject.path).to match '/tmp/'
    end
  end

  describe "#transfer_to" do
    let(:environment) { double 'Dbcp::Environment', execution_host: source_host }
    let(:destination) { double 'Dbcp::Environment', execution_host: dest_host }

    context "both local" do
      let(:source_host) { Dbcp::LocalExecutionHost.new }
      let(:dest_host)   { Dbcp::LocalExecutionHost.new }
      it "does not transfer" do
        expect(subject.transfer_to destination).to eq subject
      end
    end

    context "source local, destination remote" do
      let(:source_host) { Dbcp::LocalExecutionHost.new }
      let(:dest_host)   { Dbcp::SshExecutionHost.new }
      it "uploads to dest host" do
        expect(dest_host).to receive(:upload)
        subject.transfer_to destination
      end
    end

    context "source remote, destination local" do
      let(:source_host) { Dbcp::SshExecutionHost.new }
      let(:dest_host)   { Dbcp::LocalExecutionHost.new }
      it "downloads from source host" do
        expect(source_host).to receive(:download)
        subject.transfer_to destination
      end
    end

    context "both remote, SAME" do
      let(:source_host) { Dbcp::SshExecutionHost.new_from_uri 'ssh://staging_user@staging.example.com:2222/www/staging/current' }
      let(:dest_host)   { Dbcp::SshExecutionHost.new_from_uri 'ssh://staging_user@staging.example.com:2222/www/staging/current' }
      it "does not transfer" do
        expect(subject.transfer_to destination).to eq subject
      end
    end

    context "both remote, DIFFERENT" do
      let(:source_host) { Dbcp::SshExecutionHost.new host: 'prd.example.com' }
      let(:dest_host)   { Dbcp::SshExecutionHost.new host: 'stg.example.com' }
      it "downloads from source host" do
        expect(source_host).to receive(:download)
        expect(dest_host).to receive(:upload)
        subject.transfer_to destination
      end
    end
  end

  describe "#delete" do
    it "has the host execute rm" do
      expect(execution_host).to receive(:execute) do |command|
        expect(command).to match 'rm'
      end

      subject.delete
    end
  end

end
