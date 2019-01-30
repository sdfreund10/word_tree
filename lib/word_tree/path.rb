# frozen_string_literal: true

module WordTree
  class Path
    class NoPathError < RuntimeError; end

    def initialize(start_word, end_word)
      @start_word = start_word
      @end_word = end_word
      validate_words
    end

    def same_length_words
      WordTree::EnglishWords.with_length(@start_word.length)
    end

    def full_tree
      @levels || compute_full_tree
    end

    def trimmed_tree
      @trimmed_tree || trim_levels
    end

    def complete?
      @levels.last.include? @end_word
    end

    def dead_end?
      @levels.last.empty?
    end

    private

    def compute_full_tree
      @levels = [[@start_word]]
      options = same_length_words

      until complete?
        next_level = []
        @levels.last.each do |word|
          word_matches = WordTree::Word.new(word).find_children_from(options)
          next_level += word_matches
          options -= word_matches
        end

        @levels << next_level
        raise NoPathError if dead_end?
      end

      @levels
    end

    def trim_levels
      @trimmed_tree = (@levels || compute_full_tree).dup

      @trimmed_tree[-1] = [@end_word]
      @trimmed_tree.to_enum.with_index.reverse_each do |level, index|
        trim_above_level(level, index)
      end
      @trimmed_tree
    end

    def trim_above_level(words, index)
      return [] if index.zero?

      @levels[index - 1].reject! do |word|
        WordTree::Word.new(word).find_children_from(words).empty?
      end
    end

    def validate_words
      unless WordTree::EnglishWords.include?(@start_word) &&
             WordTree::EnglishWords.include?(@end_word)
        raise ArgumentError,
              "Please provide valid english words (#{@start_word}, #{@end_word})"
      end

      if @start_word.length != @end_word.length
        raise ArgumentError,
              'Provided words are not the same length '\
              "(#{@start_word}, #{@end_word})"
      end
    end
  end
end
