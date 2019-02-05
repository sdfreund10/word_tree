# frozen_string_literal: true

module FastWordTree
  module Connections
    def connections_for_words_with_lenth(length)
      if CONFIG.database.nil?
        from_file(length)
      else
        from_database(length)
      end
    end

    private

    def from_file(length)
      connection_hash = Hash.new []
      File.foreach(connection_file) do |line|
        word, *connections = line.strip.split(',')
        next unless word.length == length

        connection_hash[word] = connections
      end
      connection_hash
    end

    def from_database(length)
      require 'pg'

      PG.connect(dbname: CONFIG.database).exec_params(
        'SELECT word, connections '\
        'FROM word_tree.connections '\
        'WHERE LENGTH(word) = $1',
        [length]
      ).values.inject({}) do |hash, (word, connection)|
        hash.merge!(word => connection[1..-2].tr('\"', '').split(','))
      end
    end

    def connection_file
      File.expand_path(__dir__) + '/../util/all_connections.txt'
    end
  end
end
