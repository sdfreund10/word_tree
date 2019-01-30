# frozen_sting_literal: true

require 'test/unit'
require_relative '../lib/word_tree'

class PathTest < Test::Unit::TestCase
  def test_initialize_raises_error_if_provided_different_length_words
    assert_raise(ArgumentError) { Path.new("one", "three") }
  end

  def test_initialize_raises_error_if_invalid_start_word
    assert_raise(ArgumentError) { Path.new("asdfae", "tested") }
  end

  def test_initialize_raises_error_if_invalide_end_word
    assert_raise(ArgumentError) { Path.new("tested", "gykacd") }
  end

  def test_same_length_words_returns_all_words_with_length_of_start_word
    path = Path.new("one", "two")
    return_result = path.same_length_words
    assert(return_result.all? { |word| word.length == 3 })
  end

  def test_full_tree_computes_all_levels_of_full_tree_until_first_instance_of_end_word
    # valid paths: cry -> cly -> fly and cry -> fry -> fly
    path = Path.new("cry", "fly")
    full_tree = path.full_tree
    assert_equal(full_tree.length, 3)
    assert((%w(cly fry) - full_tree[1]).empty?)
  end

  def test_full_tree_starts_with_start_word
    path = Path.new("cry", "fly")
    full_tree = path.full_tree
    assert_equal(full_tree.first, ["cry"])
  end

  def test_full_tree_ends_with_end_word
    path = Path.new("cry", "fly")
    full_tree = path.full_tree
    assert(full_tree.last.include? "fly")
  end

  def test_trim_tree_returns_only_words_on_immediate_path
    path = Path.new("cry", "fly")
    assert_equal(
      path.trimmed_tree, 
      [%w(cry), %w(cly fry), %w(fly)]
    )
  end
end

