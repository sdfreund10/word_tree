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
      if CONFIG.database.nil?
        words_from_file.group_by(&:length)
      else
        words_from_db
      end
    end

    def self.words_from_file
      words_path = File.expand_path(__dir__) + '/../util/english_words.txt'
      File.read(words_path).split
    end

    def self.words_from_db
      require 'pg'
      PG.connect(dbname: CONFIG.database).exec(
        'SELECT LENGTH(word) as length, ARRAY_AGG(word) '\
        'FROM word_tree.words '\
        'GROUP BY length'
      ).values.inject({}) do |hash, (word, connections)|
        hash.merge!(
          word.to_i => connections[1..-2].tr('\"', '').split(',')
        )
      end
    end
  end
end
