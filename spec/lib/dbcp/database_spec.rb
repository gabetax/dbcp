require 'spec_helper'

describe Dbcp::Database do
  describe ".build" do
    context "valid type" do
      specify { expect(Dbcp::Database.build adapter: 'postgresql').to be_a(Dbcp::PostgresDatabase) }
    end

    context "invalid type" do
      specify { expect { Dbcp::Database.build adapter: 'invalid'}.to raise_error(Dbcp::Database::UnsupportedDatabaseAdapter) }
    end

  end
end
