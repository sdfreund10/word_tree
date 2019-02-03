# Word Tree

Word Tree is a ruby implementation of a [Word Ladder](https://en.wikipedia.org/wiki/Word_ladder) solver.

In a word ladder puzzle, a start and end word are desginated.
The challenge is to find the shortest path from the start word to the end word
where each step either changes 1 letter, or rearanges existing letters.

As an example, if we wanted to find a path between the
words <tt>ruby</tt> and <tt>cool</tt>, the engine will produce 5 equal length paths.

```
ruby -> rubs -> cubs -> cobs -> coos -> cool
ruby -> rubs -> robs -> cobs -> coos -> cool
ruby -> ruly -> rull -> cull -> coll -> cool
ruby -> ruly -> rull -> roll -> coll -> cool
ruby -> ruly -> rull -> roll -> rool -> cool
```

There are two different libraries to solve this puzzle.

## WordTree

This is the first implmementation. It grabs all words of the same length as the start and end words
and calculates the words that are "connected" at runtime.

This is algorithmicly VERY complex. To tell if a word is a "connection" to another word,
the total number of different letters has to be exactly 1. The absolute fastest way to do
this in ruby is by looping over each word's characters and comparing. A few slight
optimizations were made by stopping the scan when a word is found to have 2 differences,
making rejections faster, and the character array and be memoized to prevent parsing a given word's string
multiple times. Regardless, this is stil O(n^2) for matches.

Further, this algorithm uses calculates _all_ paths until it finds the first one ending with the
given end word. This means the tree of paths gets larger at every level. A small optimization
can be made by ignoring paths involving a word found earlier in another path, since it is garuanteed to
be a "slower" path. Even with this optimization, each step is exponentially more expensive.

All this to say it is fast enough for words less than 3 characters long (< 0.5 s), but performance
suffers massively beyond (5+ seconds for 4 or more character words)

## FastWordTree

The is a secondary implementation. It precomputes connections, writes them to a file,
and parses the connections into a hash.

There is a bit of start up cost in reading the file and forming the connection hash, meaning the lower
bound of FastWordTree is higher than WordTree.
For longer words, however, this library is massive perfomance improvement. Because hash table lookups
are so fast, the most expensive parts of the algorithm turns in to just keeping track of which words
have been used. Thus, it can still be unperforment for particularly long word trees, but is 1-2 orders of magnitude
faster for words of length 5 or more.


## Usage

The two classes repsonsible for computing the paths are `WordTree::PathFinder` and `FastWordTree::PathFinder`. Both
classes are initialized with a start and end word and have a `#find_paths` method than returns an array
of "paths", represented as an array.

```
WordTree::PathFinder.new("ruby", "cool").find_paths
# => [["ruby", "rubs", "cubs", "cobs", "coos", "cool"], 
#     ["ruby", "rubs", "robs", "cobs", "coos", "cool"],
#     ["ruby", "ruly", "rull", "cull", "coll", "cool"],
#     ["ruby", "ruly", "rull", "roll", "coll", "cool"],
#     ["ruby", "ruly", "rull", "roll", "rool", "cool"]]
```

```
FastWordTree::PathFinder.new("ruby", "cool").find_paths
# => [["ruby", "rubs", "cubs", "cobs", "coos", "cool"], 
#     ["ruby", "rubs", "robs", "cobs", "coos", "cool"],
#     ["ruby", "ruly", "rull", "cull", "coll", "cool"],
#     ["ruby", "ruly", "rull", "roll", "coll", "cool"],
#     ["ruby", "ruly", "rull", "roll", "rool", "cool"]]
```

word source: https://github.com/dwyl/english-words
