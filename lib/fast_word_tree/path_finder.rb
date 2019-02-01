# frozen_string_literal: true

module FastWordTree
  class PathFinder
    include Connections

    def initialize(start_word, end_word)
      @start_word = start_word
      @end_word = end_word
    end

    def find_paths
      paths = [[@start_word]]
      used_words = last_level_matches = [@start_word]

      until paths.map(&:last).include?(@end_word) || last_level_matches.empty?
        last_level_matches = []
        paths = paths.inject([]) do |summary, path|
          last_word = path.last
          last_word_connections = option_hash[last_word] - used_words

          last_level_matches += last_word_connections
          summary + last_word_connections.map { |word| [*path, word] }
        end

        used_words |= last_level_matches
      end

      paths.select! { |path| path.last == @end_word }
    end

    def option_hash
      @options ||= connections_for_words_with_lenth(@start_word.length)
    end
  end
end
