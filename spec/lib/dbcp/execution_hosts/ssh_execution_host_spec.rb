require 'spec_helper'

describe Dbcp::SshExecutionHost do
  subject { Dbcp::SshExecutionHost.new_from_uri 'ssh://staging_user@staging.example.com:2222/www/staging/current' }
  describe ".new_from_uri" do
    context "with valid uri" do
      specify do
        host = Dbcp::SshExecutionHost.new_from_uri 'ssh://staging_user@staging.example.com:2222/www/staging/current'
        expect(host).to be_a Dbcp::SshExecutionHost
        expect(host.host).to     eq 'staging.example.com'
        expect(host.port).to     eq 2222
        expect(host.username).to eq 'staging_user'
        expect(host.path).to     eq '/www/staging/current'
      end
    end

    context "with invalid uri" do
      specify do
        expect { Dbcp::SshExecutionHost.new_from_uri 'staging.example.com' }.to raise_error URI::InvalidURIError
      end
    end
  end

  describe "#execute" do
    # Not sure how to either easily unit test, or securely/portably integration test. Suggested appreciated.
  end

  describe "#download" do
    let(:path) { '/tmp/foo' }
    it "uses ssh" do
      expect(Net::SFTP).to receive(:start).with('staging.example.com', 'staging_user') { true }
      subject.download path, path
    end
  end

  describe "#upload" do
    let(:path) { '/tmp/foo' }
    it "uses SFTP" do
      expect(Net::SFTP).to receive(:start).with('staging.example.com', 'staging_user') { true }
      subject.upload path, path
    end
  end

  context "remote yaml" do
    let(:local_yaml_path) { File.expand_path('../../../../fixtures/config/remote_database.yml', __FILE__) }
    before { allow(subject).to receive(:download) { File.read local_yaml_path } }

    describe "#remote_database" do
      it "downloads and parses the YAML" do
        database = subject.remote_database 'config/database.yml', 'staging_ssh_only'
        expect(database).to be_a Dbcp::Database
        expect(database.database).to eq 'remote_staging_database'
      end
    end

    describe "#remote_yaml" do
      it "downloads and parses the YAML" do
        expect(subject.remote_yaml 'config/database.yml').to have_key('staging_ssh_only')
      end
    end
  end

end
