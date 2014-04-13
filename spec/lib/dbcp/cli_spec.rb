require 'spec_helper'

describe Dbcp::Cli do
  subject { Dbcp::Cli.new silent_stdout }
  let(:silent_stdout) { '/dev/null' }

  describe "#start" do
    context "success" do
      let(:source)      { double 'Dbcp::Environment', database: double(adapter: 'postgres'), environment_name: 'staging' }
      let(:destination) { double 'Dbcp::Environment', database: double(adapter: 'postgres'), environment_name: 'development' }
      let(:source_snapshot_file)      { double 'Dbcp::DatabaseSnapshotFile.new', path: '/tmp/foo', transfer_to: destination_snapshot_file }
      let(:destination_snapshot_file) { double 'Dbcp::DatabaseSnapshotFile.new', path: '/tmp/bar' }

      before do
        allow(Dbcp::Environment).to receive(:find).with('staging')     { source }
        allow(Dbcp::Environment).to receive(:find).with('development') { destination }
      end

      it "clones the database" do
        expect(source).to        receive(:export) { source_snapshot_file }
        expect(destination).to   receive(:import).with(destination_snapshot_file)
        expect(source_snapshot_file).to      receive(:delete)
        expect(destination_snapshot_file).to receive(:delete)

        subject.start ['staging']
      end
    end

    context "too few arguments" do
      it "exits" do
        expect { subject.start [] }.to raise_error(SystemExit)
      end
    end

    context "two different database types" do
      it "exist" do
        expect { subject.start ['development', 'sqlite'] }.to raise_error(SystemExit)
      end
    end

    context "environments are the same" do
      it "exits" do
        expect { subject.start ['development', 'development'] }.to raise_error(SystemExit)
      end
    end
  end
end
