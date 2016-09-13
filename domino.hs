module Domino where
import Bone
import Board
import HelpWithMath
import Print

board2 = boardFromValues 2 [0,0,0,1,1,1,2,1,0,2,2,2]

board3 = boardFromValues 3 [0,0,1,2,2,2,3,3,3,1,0,1,2,3,0,1,3,0,2,1]

tryadd = addBone (bone 1 0 0) [] (pos 1 1, pos 1 2)

solutionFor :: [Int] -> Solution
solutionFor values | not (count (n+2) [0..n] values) = error "This is not a valid puzzle"
                   | otherwise = solve (boardFromValues n values, newResult n) (bones n)  where n = maximum values

gameFor :: [Int] -> IO ()
gameFor values = do printBoard (boardFromValues (maximum values) values)
                    printResultList (getResults (solutionFor values))
