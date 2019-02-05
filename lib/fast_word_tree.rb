# frozen_string_literal: true

module FastWordTree
  require 'ostruct'
  CONFIG = OpenStruct.new

  def self.configure
    yield(CONFIG)
  end

  require_relative 'fast_word_tree/connections.rb'
  require_relative 'fast_word_tree/path_finder.rb'
end
