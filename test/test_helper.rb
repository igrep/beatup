require 'crispy'
require 'beatup'

module TestHelper
  class TestCase < Test::Unit::TestCase
    teardown { ::Crispy::CrispyWorld.reset }
  end
end
