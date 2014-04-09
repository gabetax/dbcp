require 'spec_helper'

describe Dbcp::Database do
  describe ".build" do
    context "supported type" do
      specify { expect(Dbcp::Database.build 'adapter' => 'postgresql').to be_a(Dbcp::PostgresDatabase) }
    end

    context "no type" do
      specify { expect { Dbcp::Database.build 'adapter' => nil}.to raise_error(Dbcp::Database::BlankDatabaseDefinition) }
    end

    context "unsupported type" do
      specify { expect { Dbcp::Database.build 'adapter' => 'unsupported'}.to raise_error(Dbcp::Database::UnsupportedDatabaseAdapter) }
    end

  end
end
