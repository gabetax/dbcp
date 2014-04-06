require 'spec_helper'

describe Dbcp::Cli do
  subject { Dbcp::Cli.new silent_stdout }
  let(:silent_stdout) { '/dev/null' }

  before { Dir.chdir lib = File.expand_path('../../../fixtures', __FILE__) }

  describe "#start" do
    context "success" do
      let(:source)      { double 'Dbcp::Environment', database: double(adapter: 'postgres'), environment_name: 'staging', export: snapshot_file }
      let(:destination) { double 'Dbcp::Environment', database: double(adapter: 'postgres'), environment_name: 'development', import: nil }
      let(:snapshot_file) { Dbcp::DatabaseSnapshotFile.new }

      it "clones the database" do
        allow(Dbcp::Environment).to receive(:find).with('staging') { source }
        allow(Dbcp::Environment).to receive(:find).with('development') { destination }

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
