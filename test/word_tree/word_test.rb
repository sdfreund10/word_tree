# frozen_string_literal: true

# frozen_sting_literal: true

require 'minitest/autorun'
require_relative '../../lib/word_tree'

module WordTree
  class WordTest < MiniTest::Test
    def test_sets_value
      test_word = Word.new('test')
      assert_equal(test_word.value, 'test')
    end

    def test_raises_error_if_initialized_with_non_string
      assert_raises(ArgumentError) { Word.new(nil) }
    end

    def test_one_char_from_calculates_returns_true_if_distance_less_than_2
      word = Word.new('test')
      assert(word.one_char_from?(Word.new('test')))
      assert(word.one_char_from?(Word.new('tost')))
    end

    def test_one_char_from_calculates_returns_false_if_distance_more_than_2
      word = Word.new('test')
      assert(!word.one_char_from?(Word.new('took')))
    end

    def test_anagram_of_returns_true_if_word_has_same_letters
      word = Word.new('test')
      assert(word.anagram_of?(Word.new('sett')))
    end

    def test_anagram_of_returns_false_if_different_letters
      word = Word.new('test')
      assert(!word.anagram_of?(Word.new('tast')))
    end

    def test_find_children_of_selects_words_one_letter_from_and_anagrams
      word = Word.new('test')
      options = %w[tast task sett].map { |word| Word.new(word) }
      expected = %w[sett tast]
      assert_equal(word.find_children_from(options).map(&:value).sort, expected.sort)
    end
  end
end
