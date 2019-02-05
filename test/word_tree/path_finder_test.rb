# frozen_string_literal: true

# frozen_sting_literal: true

require 'test/unit'
require_relative '../../lib/word_tree'

module WordTree
  class PathFinderTest < Test::Unit::TestCase
    def test_initialize_raises_error_if_provided_different_length_words
      assert_raise(ArgumentError) { PathFinder.new('one', 'three') }
    end

    def test_initialize_raises_error_if_invalid_start_word
      assert_raise(ArgumentError) { PathFinder.new('asdfae', 'tested') }
    end

    def test_initialize_raises_error_if_invalide_end_word
      assert_raise(ArgumentError) { PathFinder.new('tested', 'gykacd') }
    end

    def test_same_length_words_returns_all_words_with_length_of_start_word
      path = PathFinder.new('one', 'two')
      return_result = path.same_length_words
      assert(return_result.all? { |word| word.length == 3 })
    end

    def test_full_tree_computes_all_levels_of_full_tree_until_first_instance_of_end_word
      # valid paths: cry -> cly -> fly and cry -> fry -> fly
      path = PathFinder.new('cry', 'fly')
      full_tree = path.full_tree
      assert_equal(full_tree.length, 3)
      assert((%w[cly fry] - full_tree[1].map(&:value)).empty?)
    end

    def test_full_tree_starts_with_start_word
      path = PathFinder.new('cry', 'fly')
      full_tree = path.full_tree
      assert_equal(full_tree.first.map(&:value), ['cry'])
    end

    def test_full_tree_ends_with_end_word
      path = PathFinder.new('cry', 'fly')
      full_tree = path.full_tree
      assert(full_tree.last.map(&:value).include?('fly'))
    end

    def test_trim_tree_returns_only_words_on_immediate_path
      path = PathFinder.new('cry', 'fly')
      assert_equal(
        path.find_paths,
        [%w[cry cly fly], %w[cry fry fly]]
      )
    end
  end
end
