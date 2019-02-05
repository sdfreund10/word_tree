# frozen_string_literal: true

module WordTree
  class Word
    attr_reader :value, :value_chars, :value_chars_sorted
    def initialize(word)
      unless word.is_a? String
        raise ArgumentError, "Word value must be a string (#{word})"
      end

      @value = word
      @value_chars = value.chars
      @value_chars_sorted = @value_chars.sort
    end

    def one_char_from?(word)
      diff_count = 0
      value_chars.each_with_index do |letter, index|
        diff_count += 1 if letter != word.value_chars[index]
        return false if diff_count > 1
      end

      true
    end

    def anagram_of?(word)
      word.value_chars_sorted == value_chars_sorted
    end

    def find_children_from(options)
      options.select do |word|
        anagram_of?(word) || one_char_from?(word)
      end
    end
  end
end
