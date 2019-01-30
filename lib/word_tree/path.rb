# frozen_string_literal: true

class Path
  class NoPathError < RuntimeError; end

  def initialize(start_word, end_word)
    unless EnglishWords.include?(start_word) && EnglishWords.include?(end_word)
      raise ArgumentError,
            "Please provide valid english words (#{start_word}, #{end_word})"
    end

    if start_word.length != end_word.length
      raise ArgumentError,
            "Provided words are not the same length (#{start_word}, #{end_word})"
    end

    @start_word = start_word
    @end_word = end_word
  end

  def same_length_words
    EnglishWords.with_length(@start_word.length)
  end

  def full_tree
    @levels || compute_full_tree
  end

  def trimmed_tree
    @trimmed_tree || trim_levels
  end

  def complete?
    @levels.last.include? @end_word
  end

  def dead_end?
    @levels.last.empty?
  end

  private

  def compute_full_tree
    @levels = [[@start_word]]
    options = same_length_words

    until complete?
      next_level = []
      @levels.last.each do |word|
        next_level += Word.new(word).find_children_from(options)
      end

      options -= next_level
      @levels << next_level

      raise NoPathError if dead_end?
    end

    @levels
  end

  def trim_levels
    @trimmed_tree = (@levels || compute_full_tree).dup

    @trimmed_tree[-1] = [@end_word]
    @trimmed_tree.to_enum.with_index.reverse_each do |level, index|
      trim_above_level(level, index)
    end
    @trimmed_tree
  end

  def trim_above_level(words, index)
    return [] if index.zero?
    @levels[index - 1].reject! do |word|
      Word.new(word).find_children_from(words).empty?
    end
  end
end

