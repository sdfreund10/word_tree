# frozen_string_literal: true

require 'test/unit'
require_relative '../../lib/fast_word_tree'

module FastWordTree
  class PathFinderTest < Test::Unit::TestCase
    def test_options_hash_selects_connection_hash_for_words_with_same_length
      path = PathFinder.new('ruby', 'roll')
      assert(path.option_hash.keys.all? { |word| word.length == 4 })
    end

    def test_find_paths_returns_an_array_of_paths
      paths = PathFinder.new('jam', 'jib').find_paths
      assert(
        paths.include?(%w[jam jab jib])
      )
    end
  end
end
