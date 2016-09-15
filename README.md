# Domino

## What does it do?
A full set of dominoes contains every unique combination of the numbers 0 to 6 exactly once. Let's call that a full 6-pip domino set. These dominoes can be laid out in a 7x8 grid. Given this grid, it is possible to reconstruct one or more layouts of the dominoes. This domino script will reconstruct the possible layout of dominoes for any full n-pip domino set.

### Strategy
#### 1: Select place for bone
All possible solutions are investigated by taking the/a domino with the least possible moves, and doing the same for every possible outcome of placing that domino. This constructs a tree of possible outcomes.

##### Alternatives
This algorithm might be improved by cutting of branches of the tree earlier when certain conditions have been fullfilled. For example, if we see the positions on the grid that have not been 'filled' yet as a graph with neighbouring fields connected, this graph starts out as a group. If, by removing nodes and edges through placing dominoes, the graph transforms to have two groups, there can be no more solutions if one (and consequently both) have an odd number of nodes. However, the overhead of such an investigation will likely only be beneficial for large graphs after a certain number of dominoes have been laid.

#### 2: Select bone for place
A superior solution is to traverse the grid and find all possible domino's for a given position. This will only give two altenatives for each iteration.

#### Discarding impossible puzzles early
The Domino script only will search for solutions in a grid that it believes to be a domino puzzle. A valid puzzle has at least the following properties: if the largest pip is `n`, the total number of pips must be `(n+1)(n+2)` and each pip must be in the puzzle exactly `n+2` times.

## Implementation
To solve the puzzle, I've created types to represent bones/dominoes (`Bone`), positions on the board (`Position`), the state of the board with pip values that have not been assigned to a bone yet (`Board`), the result of the dominoes that have been laid done (`Result`). The state of a game can be fully represented by a `Board`, a `Result` and the list of `Bones` that are still left (it might also be possible to leave out the list, but then it would constantly be necessary to deduce that list from the `Result`).

I've created a `Solution` data type to represent the recursive structure of moves and next possible moves: `data Solution = Move (Board,Result,Bones) [Solution] | Solved Result`, together with `solve` a function that computes this given an initial state.

This setup provides the freedom to change strategies by altering or expanding the function that determines the next move(s).

## How to use
Load the Domino module in your ghci console: `:load domino.hs`.
Let the program solve your domino puzzle by calling the function `gameFor` with an `Int` list representing your puzzle, and a `Char` for the strategy of choice. E.g. solve this puzzle

```
  0   0   0   1
  1   1   2   1
  0   2   2   2
 ```
by calling
```gameFor [0,0,0,1,1,1,2,1,0,2,2,2] 'b'```.

`'b'` is the bone-based strategy, `'p'` is the place-based strategy. When using any random char, the place-based strategy will be used.

For convenience 4 example lists are included (`example1`...`example4`), so start by trying `gameFor example1`. Examples 3 and 4 are the examples from the assignment description.


### Remark on the tests
Should anyone want to run the (virtually non-existent) test suite, [Test.QuickCheck](https://hackage.haskell.org/package/QuickCheck) is required. Load `test.hs` and call `test`.