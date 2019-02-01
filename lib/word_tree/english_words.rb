# frozen_string_literal: true

module WordTree
  class EnglishWords
    def self.with_length(length)
      grouped_by_length.fetch(length, [])
    end

    def self.include?(word)
      with_length(word.length).include? word
    end

    def self.grouped_by_length
      @grouped_by_length ||= words.group_by(&:length)
    end

    def self.words
      words_path = File.expand_path(__dir__) + '/../util/english_words.txt'
      File.read(words_path).split
    end
  end
end
