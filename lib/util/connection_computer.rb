# frozen_string_literal: true

require_relative '../word_tree/word'
require 'set'
require 'pry'

class ConnectionComputer
  def initialize(words)
    @words = words.map { |word| WordTree::Word.new(word) }
  end

  def connections
    connection_hash = Hash.new([])

    while word = @words.shift
      word_connections = word.find_children_from(@words)
      connection_hash[word.value] |= word_connections.map(&:value)
      word_connections.each do |connection|
        connection_hash[connection.value] |= [word.value]
      end

      yield if block_given?
    end

    connection_hash
  end

  def self.compute_all_connections
    file_data.group_by(&:length).each do |length, words|
      puts "Starting words with length #{length}"
      completed = 0
      total = words.length
      print "#{completed.to_s.rjust(8, ' ')}/#{total}\r"
      connections = new(words).connections do
        completed += 1
        print "#{completed.to_s.rjust(8, ' ')}/#{total}\r"
      end

      print_to_file(connections)
      puts
    end
  end

  def self.print_to_file(connections)
    connections.each do |word, word_connections|
      output_file.print [word, *word_connections].join(','), "\n"
    end
  end

  def self.output_file
    @@output_file ||= File.open(__dir__ + '/all_connections.txt', 'w')
  end

  def self.file_data
    File.read(__dir__ + '/english_words.txt').split
  end
end
