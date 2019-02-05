# frozen_string_literal: true

module FastWordTree
  class PathFinder
    include Connections

    def initialize(start_word, end_word)
      @start_word = start_word
      @end_word = end_word
      @paths = [[@start_word]]
      @used_words = [@start_word]
      validate_words
    end

    def find_paths
      last_level_matches = [@start_word]

      until complete? || last_level_matches.empty?
        last_level_matches = []
        connection_hash = next_level_connections
        @paths = @paths.inject([]) do |summary, path|
          last_word = path.last
          last_word_connections = connection_hash[last_word]
          last_level_matches += last_word_connections
          summary + last_word_connections.map { |word| [*path, word] }
        end

        @used_words += last_level_matches.uniq
      end

      @paths.select! { |path| path.last == @end_word }
    end

    def complete?
      last_level.include? @end_word
    end

    def last_level
      @paths.map(&:last)
    end

    def option_hash
      @option_hash ||= connections_for_words_with_lenth(@start_word.length)
    end

    def next_level_connections
      if RUBY_VERSION > '2.5.0'
        option_hash.slice(*last_level).transform_values! do |connections|
          connections - @used_words
        end
      else
        reduced_hash = option_hash.select { |word, _| last_level.include? word }
        reduced_hash.each do |word, connections|
          reduced_hash[word] = connections - @used_words
        end
      end
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
