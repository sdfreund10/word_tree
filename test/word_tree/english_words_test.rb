# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/word_tree'

module WordTree
  class EnglishWordsTest < MiniTest::Test
    def test_words_with_lenth_returns_english_words_with_given_length
      words = EnglishWords.with_length(3)
      assert(words.all? { |word| word.length == 3 })
    end

    def test_words_with_lenth_returns_empty_array_if_no_words_found
      assert_equal([], EnglishWords.with_length(0))
    end

    def test_include_returns_true_for_valid_english_word
      assert(EnglishWords.include?('hello'))
    end

    def test_include_returns_false_for_invalid_english_word
      assert_equal false, EnglishWords.include?('asdfg')
    end

    def test_words_with_length_works_with_database
      WordTree.configure { |config| config.database = 'word_tree' }
      assert(EnglishWords.with_length(3).all? { |word| word.length == 3 })
      assert_equal([], EnglishWords.with_length(0))
    ensure
      WordTree.configure { |config| config.database = nil }
    end

    def test_include_works_with_database
      WordTree.configure { |config| config.database = 'word_tree' }
      assert(EnglishWords.include?('hello'))
      assert_equal false, EnglishWords.include?('asdfg')
    ensure
      WordTree.configure { |config| config.database = nil }
    end
  end
end
