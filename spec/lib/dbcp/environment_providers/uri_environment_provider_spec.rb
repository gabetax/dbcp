require 'spec_helper'

describe Dbcp::UriEnvironmentProvider do
  describe "#find" do
    context "when a URI" do
      let(:uri) { 'postgres://my_username:my_password@db.example.com:5432/my_database' }
      it "returns an environment" do
        environment = subject.find(uri)
        expect(environment).to be_a Dbcp::Environment
        expect(environment.environment_name).to eq uri
        expect(environment.database).to be_a Dbcp::PostgresDatabase
        expect(environment.database.username).to eq 'my_username'
        expect(environment.database.password).to eq 'my_password'
        expect(environment.database.host).to eq 'db.example.com'
        expect(environment.database.database).to eq 'my_database'
      end
    end

    context "when not a valid URI" do
      let(:uri) { 'development'}
      specify { expect(subject.find(uri)).to be_nil }
    end
  end
end
