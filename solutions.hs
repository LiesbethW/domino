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

solve :: (Board,Result,Bones) -> SolutionStrategy -> Solution
solve (input,output,[]) strategy = Solved output
solve (input,output,bones) strategy = Move (input,output,bones) [ solve x strategy | x <- strategy (input,output,bones) ]

-- Solution strategies
type SolutionStrategy = (Board,Result,Bones) -> [(Board,Result,Bones)]

-- Strategy 1
boneBased :: SolutionStrategy
boneBased (input,output,bones) = [ (board,result,bs) | (board,result) <- possibleMoves input output b ]
  where
    (b:bs) = bestBoneFirst (input,output,bones)

bestBoneFirst :: (Board,Result,Bones) -> Bones
bestBoneFirst (input,output,bones) = bones'
  where (bones',_) = (unzip . sortBy (\(_,m1) (_,m2) -> compare m1 m2)) [ (b, length (validPlaces input b)) | b <- bones ]

possibleMoves :: Board -> Result -> Bone -> [(Board,Result)]
possibleMoves input output stone = map (placePiece (input,output) stone) (validPlaces input stone)

-- Strategy 2
placeBased :: SolutionStrategy
placeBased (input,output,bones) = [ (board,result,remove b bones) | ((board,result),b) <- nextPlace input output bones ]

places :: Board -> [((Value,Value),(Position,Position))]
places board = [ ((snd (next board), val),(fst (next board),pos)) | (pos,val) <- neighbours (fst (next board)) board]

nextPlace :: Board -> Result -> Bones -> [((Board,Result),Bone)]
nextPlace board result bones = [ (placePiece (board,result) bone positions, bone) | (values,positions) <- places board, bone <- bones, matchingBone values bone ]
