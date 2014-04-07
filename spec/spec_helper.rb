if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require_relative '../lib/dbcp'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each { |f| require f }

