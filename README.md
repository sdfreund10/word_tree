# word_tree

Word tree is an an algorithm that finds the shortest path(s) from one word to
another, changing one letter at a time, using only valid english words at each step.

As an example, if we wanted to find a path between the
words <tt>ruby</tt> and <tt>cool</tt>, the engine will produce 5 equal length paths.

```
"ruby" -> "ruly" -> "rull" -> "cull" -> "coll" -> "cool"
"ruby" -> "ruly" -> "rull" -> "roll" -> "coll" -> "cool"
"ruby" -> "ruly" -> "rull" -> "roll" -> "rool" -> "cool"
"ruby" -> "rubs" -> "cubs" -> "cobs" -> "coos" -> "cool"
"ruby" -> "rubs" -> "robs" -> "cobs" -> "coos" -> "cool"
```

# How it works

This algorithm uses a breadth-first search pattern. It starts by finding all words
that differ from the starting word by one letter. Then it finds all words that
can be reached by changing one letter of those words, and so forth until the
space of words that can be reached contains the target word.

On a technical level, this is accomplished with regular expressions, lots of looping,
and a basic tree implementation.

## Limitations

The use of breadth-first searching is naturally very memory-intensive for very large branches.
This is generally fine for 3-letter words and most 4-letter words, but can be intensive
for 5-letter words and longer. A depth-first implementation would likely be better for these situations.

## Todo

- Implement depth-first search
- Build UI
- Optimize algorithm for memory

## Kudos

word source: https://github.com/dwyl/english-words