# frozen_string_literal: true

require 'test/unit'
require_relative '../../lib/util/connection_computer'

class ConnectionComputerTest < Test::Unit::TestCase
  def test_connections_returns_hash
    computer = ConnectionComputer.new(%w(test sett best bust))
    assert(computer.connections.is_a? Hash)
  end

  def test_connections_has_key_for_each_provided_word
    sample_words = %w(test sett best bust)
    computer = ConnectionComputer.new(sample_words)
    assert_equal(
      computer.connections.keys.sort,
      sample_words.sort
    )
  end

  def test_connections_returns_connections_among_provided_words
    computer = ConnectionComputer.new(%w(test best bust))
    assert_equal(
      computer.connections,
      {
        "test" => ["best"],
        "best" => ["test", "bust"],
        "bust" => ["best"]
      }
    )
  end
end
