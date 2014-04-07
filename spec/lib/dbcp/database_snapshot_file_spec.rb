require 'spec_helper'

describe Dbcp::DatabaseSnapshotFile do
  subject { Dbcp::DatabaseSnapshotFile.new environment }
  let(:environment) { double 'Dbcp::Environment' }

  describe "#path" do
    it "defines a temporary path" do
      expect(subject.path).to match '/tmp/'
    end
  end

end
