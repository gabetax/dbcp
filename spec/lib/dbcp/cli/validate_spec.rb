require 'spec_helper'

describe Dbcp::Cli::Validator do

  subject { Dbcp::Cli::Validator }
  let(:mysql_source)      { double 'Dbcp::Environment', database: double(adapter: 'mysql'), environment_name: 'staging' }
  let(:mysql_destination) { double 'Dbcp::Environment', database: double(adapter: 'mysql'), environment_name: 'development' }
  let(:postgres_destination) { double 'Dbcp::Environment', database: double(adapter: 'postgres'), environment_name: 'development' }

  describe "#run" do

    context "two different database types" do
      it "exits" do
        expect { subject.new(mysql_source, postgres_destination).run }.to raise_error(SystemExit)
      end
    end

    context "environments are the same" do
      it "exits" do
        expect { subject.new(mysql_source, mysql_source).run }.to raise_error(SystemExit)
      end
    end

    context "environments are different and database types are the same" do
      it "runs successfully" do
        expect { subject.new(mysql_source, mysql_destination).run }.to_not raise_error
      end
    end
  end
end
