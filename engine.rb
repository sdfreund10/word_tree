# frozen_string_literal: true

class Path
  Node = Struct.new(:parent, :value, :children)
  def initialize(original, final)
    @original = original
    @final = final
    @possible_words = same_length_words - [@original]
  end

  def same_length_words
    File.open("words_alpha.txt").select do |word|
      word.strip.size == @original.size
    end.map(&:strip)
  end

  def find_path
    tree = matches(@original)
    current_level = tree
    until @possible_words.empty? || current_level.flat_map(&:children).include?(@final) || current_level.flat_map(&:children).empty?
      current_level.each { |node| node.children.map! { |word| matches(word, node) } }
      current_level = current_level.map(&:children).flatten
      @possible_words -= current_level.flat_map(&:children)
    end
    current_level.select { |node| node.children.include?(@final) }.map do |node|
      path_to_top(node)
    end
  end

  def path_to_top(node)
    path = [node.value, @final]
    parent = node.parent
    until parent.nil?
      path.unshift parent.value
      parent = parent.parent
    end
    path
  end

  def matches(word, parent = nil)
    regex_array(word).map do |pattern|
      Node.new(parent, word, @possible_words.select { |poss| pattern.match poss })
    end
  end

  def regex_array(word)
    word.split("").map.with_index do |_, i|
      pattern = word.dup
      pattern[i] = "."
      Regexp.new pattern
    end
  end
end
