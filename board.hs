module Board where
import Bone
import HelpWithMath
import Text.Printf

-- Value
data Value = Maybe Int | Empty

int :: Value -> Int
int (Maybe n) = n
int (Empty)   = -1

instance Show Value where
  show (Maybe n) = printf "%3u" n
  show (Empty)   = printf "%3s" "-"

instance Eq Value where
  Maybe n == Maybe m = n == m
  Empty == Empty     = True
  _ == _             = False

-- Position
type Position = (Int, Int)
pos_x :: Position -> Int
pos_x (x,_) = x

pos_y :: Position -> Int
pos_y (_,y) = y

pos :: Int -> Int -> Position
pos x y = (x,y)

positions :: Int -> [Position]
positions n = [ (x,y) | x <- [1..(n+1)], y <- [1..(n+2)] ]

data Side = Left' | Right' | Up' | Down'

neighbour :: Position -> Side -> Position
neighbour (x,y) Left'  = (x - 1, y)
neighbour (x,y) Right' = (x + 1, y)
neighbour (x,y) Up'    = (x, y - 1)
neighbour (x,y) Down'  = (x, y + 1)

-- PositionMap
type Grid a = [(Position, a)]

height :: Grid a -> Int
height grid = maximum [ pos_x p | (p,_) <- grid ]

width :: Grid a -> Int
width grid = maximum [ pos_y p | (p,_) <- grid ]

-- Board
type Board = Grid Value

emptyBoard :: Int -> Board
emptyBoard n = zip (positions n) (repeat Empty)

boardFromValues :: Int -> [Int] -> Board
boardFromValues n values | (length values) /= (length (positions n)) = error "Provide exactly as many values as fit the board"
                         | otherwise = zip (positions n) [ Maybe x | x <- values ]

allEmpty :: Board -> Bool
allEmpty board = all (\(p,v) -> v == Empty) board

neighbours :: Position -> Board -> [(Position, Value)]
neighbours pos board = [ (p,v) | (p,v) <- board, inList p [neighbour pos Left', neighbour pos Right', neighbour pos Up', neighbour pos Down'] ]

-- Piece
data Piece = Number Int | None

piece :: Bone -> Piece
piece b = Number (number b)

instance Eq Piece where
  Number n == Number m = n == m
  None == None         = True
  _ == _               = False

instance Show Piece where
  show (Number x) = printf "%3u" x
  show (None)     = printf "%3s" "-"

-- Result
type Result = Grid Piece

newResult :: Int -> Result
newResult n = zip (positions n) (repeat None)

-- Solution
data Solution = Move (Board,Result) Bones [Solution] | Solved Result | GameOver

getResults :: Solution -> [Result]
getResults (Solved result)      = [result]
getResults GameOver             = []
getResults (Move _ _ solutions) = (concat . map getResults) solutions

solve :: (Board,Result) -> Bones -> Solution
solve (input,output) [] = Solved output
solve (input,output) (b:bs) = Move (input,output) (b:bs) [ solve (input',output') bs | (input', output') <- possibleMoves input b output ]

possibleMoves :: Board -> Bone -> Result -> [(Board,Result)]
possibleMoves input stone output = uniq (map (placePiece (input,output) stone) (validPlaces input stone))

isValidPlace :: Board -> Bone -> (Position,Position) -> Bool
isValidPlace board stone (pos1,pos2) = int (findValue pos1 board) == pip1 stone && int (findValue pos2 board) == pip2 stone

validPlaces :: Board -> Bone -> [(Position,Position)]
validPlaces board stone = [ (pos1,pos2) | (pos1,val1) <- board, (pos2,val2) <- neighbours pos1 board, int val1 == pip1 stone, int val2 == pip2 stone ]

placePiece :: (Board,Result) -> Bone -> (Position,Position) -> (Board, Result)
placePiece (input,output) stone (pos1,pos2) | (any (\x -> x == Empty) . map (\x -> findValue x input)) [pos1,pos2] = error "One of the positions not (free) on board."
                                            | not (isValidPlace input stone (pos1,pos2)) = error "Not a valid position."
                                            | otherwise = (input', output') where input' = removePositions (pos1,pos2) input
                                                                                  output' = addBone stone output (pos1,pos2)

getValue :: [Value] -> Value
getValue []  = Empty
getValue [x] = x

findValue :: Position -> Board -> Value
findValue pos board = getValue [ b | (p,b) <- board, p == pos ]

removePositions :: (Position,Position) -> Board -> Board
removePositions (p1,p2) board = map (\(p,v) -> if p == p1 || p == p2 then (p, Empty) else (p,v)) board

addBone :: Bone -> Result -> (Position,Position) -> Result
addBone b res (p1,p2) = map (\(p,k) -> if p == p1 || p == p2 then (p, piece b) else (p,k)) res
