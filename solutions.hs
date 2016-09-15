module Solutions where
import Bone
import Board
import HelpWithMath
import Data.List (sortBy)

-- Solution
data Solution = Move (Board,Result,Bones) [Solution] | Solved Result

getResults :: Solution -> [Result]
getResults (Solved result)      = [result]
getResults (Move _ solutions) = (concat . map getResults) solutions

solve :: (Board,Result,Bones) -> Solution
solve (input,output,[]) = Solved output
solve (input,output,bones) = Move (input,output,bones) [ solve x | x <- nextMoves (input,output,bones) ]

nextMoves :: (Board,Result,Bones) -> [(Board,Result,Bones)]
nextMoves (input,output,bones) = [ (board,result,bs) | (board,result) <- possibleMoves input output b ]
  where
    (b:bs) = bestBoneFirst (input,output,bones)

bestBoneFirst :: (Board,Result,Bones) -> Bones
bestBoneFirst (input,output,bones) = bones'
  where (bones',_) = (unzip . sortBy (\(_,m1) (_,m2) -> compare m1 m2)) [ (b, length (validPlaces input b)) | b <- bones ]

possibleMoves :: Board -> Result -> Bone -> [(Board,Result)]
possibleMoves input output stone = map (placePiece (input,output) stone) (validPlaces input stone)


