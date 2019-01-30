require_relative "./word_tree"

Path.new("cry", "fly").trim_tree.map { |level| print level, "\n" }
