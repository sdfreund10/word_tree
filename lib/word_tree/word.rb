# frozen_string_literal: true

class Word
  attr_reader :value
  def initialize(word)
    unless word.is_a? String
      raise ArgumentError, "Word value must be a string (#{word})"
    end
    @value = word
  end

  def one_char_from?(word)
    diff_count = 0
    value_chars.each_with_index do |letter, index|
      diff_count += 1 if letter != word[index]
      return false if diff_count > 1
    end

    true
  end

  def is_anagram_of?(word)
    word.chars.sort == value_chars_sorted
  end


  def find_children_from(options)
    options.select do |word|
      is_anagram_of?(word) || one_char_from?(word)
    end
  end

  private

  def value_chars
    @value_chars ||= value.chars
  end

  def value_chars_sorted
    @value_chars_sorted ||= value_chars.sort
  end
end
