module Domino where
import Bone
import Board
import HelpWithMath
import Solutions
import Print

board2 = boardFromValues 2 [0,0,0,1,1,1,2,1,0,2,2,2]

board3 = boardFromValues 3 [3,2,3,2,0,0,3,1,2,0,2,0,0,3,1,1,1,1,3,2]

trivial :: [Int]
trivial = [0,0]

example1 :: [Int]
example1 = [0,0,0,1,1,1,2,1,0,2,2,2]

example2 :: [Int]
example2 = [3,2,3,2,0,0,3,1,2,0,2,0,0,3,1,1,1,1,3,2]

example3 :: [Int]
example3 = [5,4,3,6,5,3,4,6,0,6,0,1,2,3,1,1,3,2,6,5,0,4,2,0,5,3,6,2,3,2,0,6,4,0,4,1,0,0,4,1,5,2,2,4,4,1,6,5,5,5,3,6,1,2,3,1]

example4 :: [Int]
example4 = [4,2,5,2,6,3,5,4,5,0,4,3,1,4,1,1,1,2,3,0,2,2,2,2,1,4,0,1,3,5,6,5,4,0,6,0,3,6,6,5,4,0,1,6,4,0,3,0,6,5,3,6,2,1,5,3]


solutionFor :: [Int] -> SolutionStrategy -> Solution
solutionFor values strategy | not (count (n+2) [0..n] values) = error "This is not a valid puzzle"
                            | otherwise = solve (boardFromValues n values, newResult n, newBones n) strategy where n = maximum values

solveWithStrategy :: [Int] -> SolutionStrategy -> IO ()
solveWithStrategy values strategy = do printBoard (boardFromValues (maximum values) values)
                                       printResultList (getResults (solutionFor values strategy))

gameFor :: [Int] -> Char -> IO ()
gameFor values 'b' = solveWithStrategy values boneBased
gameFor values 'p' = solveWithStrategy values placeBased
gameFor values _   = solveWithStrategy values placeBased
