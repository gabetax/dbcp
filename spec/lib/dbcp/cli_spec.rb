require 'spec_helper'

describe Dbcp::Cli do

  subject { Dbcp::Cli }

  describe "#start" do

    before do
      Dbcp::Environment.stub(:find) { 'db' }
      Dbcp::Cli::Validator.any_instance.stub(:run)
      Dbcp::Cli::Copy.any_instance.stub(:run)
    end

    it "validates the databases" do
      expect_any_instance_of(Dbcp::Cli::Validator).to receive(:run)
      subject.start []
    end

    it "copies the databases" do
      expect_any_instance_of(Dbcp::Cli::Copy).to receive(:run)
      subject.start []
    end

  end
end
