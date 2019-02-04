# frozen_string_literal: true

module FastWordTree
  module Connections
    def connections_for_words_with_lenth(length)
      connection_hash = Hash.new []
      File.foreach(connection_file) do |line|
        word, *connections = line.strip.split(',')
        next unless word.length == length

        connection_hash[word] = connections
      end
      connection_hash
    end

    private

    def connection_file
      File.expand_path(__dir__) + '/../util/all_connections.txt'
    end
  end
end
