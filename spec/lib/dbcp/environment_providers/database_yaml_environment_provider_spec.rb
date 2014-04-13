require 'spec_helper'

describe Dbcp::DatabaseYamlEnvironmentProvider do
  subject { Dbcp::DatabaseYamlEnvironmentProvider.new path }
  let(:path) { 'config/database.yml' }

  describe "#find" do
    context "when environment exists" do
      it "returns an environment" do
        environment = subject.find 'development'
        expect(environment).to be_a Dbcp::Environment
        expect(environment.database).to be_a Dbcp::Database
        expect(environment.environment_name).to  eq 'development'
        expect(environment.database.adapter).to  eq 'postgresql'
        expect(environment.database.host).to     eq 'db.example.com'
        expect(environment.database.port).to     eq 6543
        expect(environment.database.database).to eq 'dev_database'
        expect(environment.database.username).to eq 'dev_username'
        expect(environment.database.password).to eq 'dev_password'
      end

      context "without ssh_uri" do
        it "executes on localhost" do
          environment = subject.find 'development'
          expect(environment.execution_host).to be_a Dbcp::LocalExecutionHost
        end
      end

      context "with ssh_uri" do
        it "executes on remote host" do
          environment = subject.find 'staging'
          expect(environment.execution_host).to be_a Dbcp::SshExecutionHost
        end
      end

      context "without database definition, but with ssh_uri" do
        let(:remote_database) { double 'Dbcp::Database' }
        it "fetches database definition from database.yml on remote host" do
          allow_any_instance_of(Dbcp::SshExecutionHost).to receive(:remote_database) { remote_database }
          environment = subject.find 'staging_ssh_only'
          expect(environment.database).to eq remote_database
        end
      end
    end

    context "when environment doesn't exist" do
      specify { expect(subject.find 'does-not-exist').to be_nil }
    end

    context "when file doesn't exist" do
    let(:path) { File.expand_path('../../../../fixtures/config/database-does-not-exist.yml', __FILE__) }
      specify { expect(subject.find 'development').to be_nil }
    end
  end
end
