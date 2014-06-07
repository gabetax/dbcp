if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require_relative '../lib/dbcp'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) {
    Dir.chdir File.expand_path('../fixtures', __FILE__)
    Dbcp.logger = Dbcp::Log.silent
  }

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
