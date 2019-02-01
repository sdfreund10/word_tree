# frozen_string_literal: true

module FastWordTree
  module Connections
    def connections_for_words_with_lenth(length)
      File.foreach(connection_file)
          .each_with_object(Hash.new([])) do |line, connection_hash|
        word, *connections = line.strip.split(',')
        next unless word.length == length

        connection_hash[word] = connections
      end
    end

    private

    def connection_file
      File.expand_path(__dir__) + '/../util/all_connections.txt'
    end
  end
end
