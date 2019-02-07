# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/fast_word_tree'

class ConnectionsTest < MiniTest::Test
  # can take a while, so do it once at the beginining of suite
  DUMMY_CLASS = Class.new { include FastWordTree::Connections }.freeze
  TEST_OBJECT = DUMMY_CLASS.new.connections_for_words_with_lenth(4).freeze

  def test_connections_for_words_with_length_4_should_all_have_length_4
    assert(TEST_OBJECT.keys.all? { |word| word.length == 4 })
  end

  def test_connections_for_words_with_length_4_should_have_connections_as_value
    assert_equal(TEST_OBJECT['ruby'].sort, %w[bury rube rubs rudy ruly])
  end

  def test_connection_for_words_with_length_works_with_database
    FastWordTree.configure { |config| config.database = 'word_tree' }
    object = Class.new { include FastWordTree::Connections }.new
    test_object = object.connections_for_words_with_lenth(4)
    assert_equal(test_object['ruby'].sort, %w[bury rube rubs rudy ruly])
  ensure
    FastWordTree.configure { |config| config.database = nil }
  end
end
