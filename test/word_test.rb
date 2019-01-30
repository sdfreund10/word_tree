# frozen_sting_literal: true

require 'test/unit'
require_relative '../lib/word_tree'

module WordTree
  class WordTest < Test::Unit::TestCase
    def test_sets_value
      test_word = Word.new("test")
      assert_equal(test_word.value, "test")
    end
  
    def test_raises_error_if_initialized_with_non_string
      assert_raise(ArgumentError) { Word.new(nil) }
    end
  
    def test_one_char_from_calculates_returns_true_if_distance_less_than_2
      word = Word.new("test")
      assert(word.one_char_from? "test")
      assert(word.one_char_from? "tost")
    end
  
    def test_one_char_from_calculates_returns_false_if_distance_more_than_2
      word = Word.new("test")
      assert(!word.one_char_from?("took"))
    end
  
    def test_is_anagram_of_returns_true_if_word_has_same_letters
      word = Word.new("test")
      assert(word.is_anagram_of? "sett")
    end
  
    def test_is_anagram_of_returns_false_if_different_letters
      word = Word.new("test")
      assert(!word.is_anagram_of?("tast"))
    end
  
    def test_find_children_of_selects_words_one_letter_from_and_anagrams
      word = Word.new("test")
      options = %w(tast task sett)
      expected = %w(sett tast)
      assert_equal(word.find_children_from(options).sort, expected.sort)
    end
  end
end

