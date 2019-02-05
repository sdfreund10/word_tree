# frozen_string_literal: true

module WordTree
  require 'ostruct'
  CONFIG = OpenStruct.new

  def self.configure
    yield(CONFIG)
  end

  require_relative './word_tree/english_words'
  require_relative './word_tree/word'
  require_relative './word_tree/path_finder'
end
