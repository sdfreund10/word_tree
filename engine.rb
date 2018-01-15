# frozen_string_literal: true

class Path
  attr_reader :tree, :original, :final
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

  def find_paths
    # breadth-first searching
    current_level = Level.new(matches(@original))
    @possible_words - current_level.children
    until dead_end || current_level.finished(@final)
      current_level.nodes.each do |node|
        node.children.map! { |word| matches(word, node) }
      end
      current_level = Level.new(current_level.children.flatten)
      @possible_words -= current_level.children
    end
    current_level.nodes.select { |node| node.children.include?(@final) }.map(&:path_to_top)
  end

  def depth_first_search
    word_tree = Tree.new
  end

  def reset_possible_words
    same_length_words - [@original]
  end

  def matches(word, parent = nil)
    regex_array(word).map do |pattern|
      Node.new(parent, word, @possible_words.select { |poss| pattern.match poss })
    end
  end

  def dead_end
    @possible_words.empty?
  end

  def regex_array(word)
    word.split("").map.with_index do |_, i|
      pattern = word.dup
      pattern[i] = "."
      Regexp.new "^#{pattern}$"
    end
  end
end

Level = Struct.new(:nodes) do
  def empty?
    nodes.flat_map(&:children).empty?
  end

  def children
    nodes.flat_map(&:children)
  end

  def finished(target)
    children.empty? || children.include?(target)
  end
end

Node = Struct.new(:parent, :value, :children) do
  def path_to_top
    path = [value]
    next_node = parent
    until next_node.nil?
      path.unshift next_node.value
      next_node = next_node.parent
    end
    path
  end
end

