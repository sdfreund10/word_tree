# frozen_string_literal: true

module WordTree
  class PathFinder
    class NoPathError < RuntimeError; end

    def initialize(start_word, end_word)
      @start_word = start_word
      @end_word = end_word
      validate_words
    end

    def same_length_words
      WordTree::EnglishWords.with_length(@start_word.length)
    end

    def find_paths
      tree = full_tree
      all_paths = [[Word.new(@end_word)]]

      tree[0..-2].reverse_each do |level|
        all_paths = all_paths.inject([]) do |new_paths, path|
          last_word = path.last
          connections = last_word.find_children_from(level)
          new_paths + connections.map { |word| [*path, word] }
        end
      end

      all_paths.map { |path| path.map(&:value).reverse }
    end

    def full_tree
      levels = [[Word.new(@start_word)]]
      options = same_length_words.map! { |word| Word.new(word) }

      until levels.last.map(&:value).include? @end_word
        next_level = []
        levels.last.each do |word|
          word_matches = word.find_children_from(options)
          next_level.concat(word_matches)
          options -= word_matches
        end

        levels << next_level
        raise NoPathError if levels.last.empty?
      end

      levels
    end

    def validate_words
      unless @start_word && @end_word &&
             WordTree::EnglishWords.include?(@start_word) &&
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
