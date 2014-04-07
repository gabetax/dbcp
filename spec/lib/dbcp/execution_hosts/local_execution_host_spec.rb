require 'spec_helper'

describe Dbcp::LocalExecutionHost do

  describe "==" do
    specify { expect(Dbcp::LocalExecutionHost.new).to eq Dbcp::LocalExecutionHost.new }
  end
end
