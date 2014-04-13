require 'spec_helper'

describe Dbcp::Capistrano3EnvironmentProvider do
  subject { Dbcp::Capistrano3EnvironmentProvider.new }

  describe "#find" do
    context "when task exists" do
      let(:remote_database) { double 'Database' }
      it "returns an environment" do
        allow_any_instance_of(Dbcp::SshExecutionHost).to receive(:remote_database) { remote_database }
        environment = subject.find 'staging'
        expect(environment).to be_a Dbcp::Environment
        expect(environment.environment_name).to  eq 'staging'
        expect(environment.execution_host).to be_a Dbcp::SshExecutionHost
        expect(environment.execution_host.host).to eq 'db.example.com'
        expect(environment.execution_host.username).to eq 'staging_user'
        expect(environment.execution_host.path).to eq '/www/staging.example.com/current'
        expect(environment.database).to eq remote_database
      end
    end

    context "when task doesn't exist" do
      specify do
        expect(subject.find('doesnt-exist')).to be_nil
      end
    end

    context "Capfile does't exist" do
      let(:path) { 'doesnt-exist' }
      specify do
        expect(subject.find('production')).to be_nil
      end
    end
  end


end
