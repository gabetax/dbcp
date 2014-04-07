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


end
