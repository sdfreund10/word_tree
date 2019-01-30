# frozen_string_literal: true

class EnglishWords
  def self.with_length(n)
    grouped_by_length.fetch(n, [])
  end

  def self.include?(word)
    with_length(word.length).include? word
  end

  private

  def self.grouped_by_length
    @grouped_by_length ||= words.group_by(&:length)
  end

  def self.words
    words_path = File.expand_path(__dir__) + '/english_words.txt'
    File.read(words_path).split
  end
end

