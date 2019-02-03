# frozen_string_literal: true

module FastWordTree
  class PathFinder
    include Connections

    def initialize(start_word, end_word)
      @start_word = start_word
      @end_word = end_word
      @paths = [[@start_word]]
      @used_words = [@start_word]
    end

    def find_paths
      used_words = last_level_matches = [@start_word]

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
      @options ||= connections_for_words_with_lenth(@start_word.length)
    end

    def next_level_connections
      option_hash.slice(*last_level).transform_values! { |connections| connections - @used_words }
    end
  end
end
