module Solutions where
import Bone
import Board
import HelpWithMath

-- Solution
data Solution = Move (Board,Result) Bones [Solution] | Solved Result | GameOver

getResults :: Solution -> [Result]
getResults (Solved result)      = [result]
getResults GameOver             = []
getResults (Move _ _ solutions) = (concat . map getResults) solutions

solve :: (Board,Result,Bones) -> Solution
solve (input,output,[]) = Solved output
solve (input,output,bones) = Move (input,output) bones [ solve x | x <- nextMoves (input,output,bones) ]

nextMoves :: (Board,Result,Bones) -> [(Board,Result,Bones)]
nextMoves (input,output,b:bs) = [ (board,result,bs) | (board,result) <- possibleMoves input b output ]

possibleMoves :: Board -> Bone -> Result -> [(Board,Result)]
possibleMoves input stone output = uniq (map (placePiece (input,output) stone) (validPlaces input stone))


