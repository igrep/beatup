if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

base_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
lib_dir  = File.join(base_dir, 'lib')
test_dir = File.join(base_dir, 'test')

$LOAD_PATH.unshift(lib_dir)
require 'test/unit'

$LOAD_PATH.unshift(test_dir)

require 'test_helper'

exit Test::Unit::AutoRunner.run(true, test_dir)
