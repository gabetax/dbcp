require 'spec_helper'

describe Dbcp::ExecutionHost do
  describe ".build" do
    context "when ssh information is present" do
      let(:environment_hash) { { 'ssh_uri' => 'ssh://staging_user@staging.example.com/www/staging/current' } }
      specify { expect(Dbcp::ExecutionHost.build(environment_hash)).to be_a Dbcp::SshExecutionHost }
    end

    context "without ssh information" do
      specify { expect(Dbcp::ExecutionHost.build({})).to be_a Dbcp::LocalExecutionHost }
    end
  end
end
