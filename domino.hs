module Domino where
import Bone
import Board
import HelpWithMath
import Print

board2 = boardFromValues 2 [0,0,0,1,1,1,2,1,0,2,2,2]

board3 = boardFromValues 3 [0,0,1,2,2,2,3,3,3,1,0,1,2,3,0,1,3,0,2,1]

example1 :: [Int]
example1 = [5,4,3,6,5,3,4,6,0,6,0,1,2,3,1,1,3,2,6,5,0,4,2,0,5,3,6,2,3,2,0,6,4,0,4,1,0,0,4,1,5,2,2,4,4,1,6,5,5,5,3,6,1,2,3,1]

example2 :: [Int]
example2 = [4,2,5,2,6,3,5,4,5,0,4,3,1,4,1,1,1,2,3,0,2,2,2,2,1,4,0,1,3,5,6,5,4,0,6,0,3,6,6,5,4,0,1,6,4,0,3,0,6,5,3,6,2,1,5,3]

tryadd = addBone (bone 1 0 0) [] (pos 1 1, pos 1 2)

solutionFor :: [Int] -> Solution
solutionFor values | not (count (n+2) [0..n] values) = error "This is not a valid puzzle"
                   | otherwise = solve (boardFromValues n values, newResult n) (bones n)  where n = maximum values

gameFor :: [Int] -> IO ()
gameFor values = do printBoard (boardFromValues (maximum values) values)
                    printResultList (getResults (solutionFor values))
