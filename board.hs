module Board where
import Bone
import HelpWithMath

-- Value
data Value = Maybe Int | Empty

int :: Value -> Int
int (Maybe n) = n

instance Show Value where
  show (Maybe n) = show n
  show (Empty)   = "-"

instance Eq Value where
  Empty == Empty     = True
  Maybe _ == Empty   = False
  Empty == Maybe _   = False
  Maybe n == Maybe m = n == m

-- Position
type Position = (Int, Int)
pos_x :: Position -> Int
pos_x (x,_) = x

pos_y :: Position -> Int
pos_y (_,y) = y

pos :: Int -> Int -> Position
pos x y = (x,y)

-- Board
type Board = [(Position, Value)]

board_x :: Board -> Int
board_x board = maximum [ pos_x p | (p,v) <- board ]

board_y :: Board -> Int
board_y board = maximum [ pos_y p | (p,v) <- board ]

-- Result
type Result = [(Position, Bone)]

positions :: Int -> [Position]
positions n = [ (x,y) | x <- [1..(n+2)], y <- [1..(n+1)] ]

emptyBoard :: Int -> Board
emptyBoard n = zip (positions n) (repeat Empty)

boardFromValues :: Int -> [Int] -> Board
boardFromValues n values | (length values) /= (length (positions n)) = error "Provide exactly as many values as fit the board"
                         | otherwise = zip (positions n) [ Maybe x | x <- values ]

data Solution = Move Board Bones Result [Solution] | Solved Result | GameOver

data Side = Left' | Right' | Up' | Down'

neighbour :: Position -> Side -> Position
neighbour (x,y) Left'  = (x - 1, y)
neighbour (x,y) Right' = (x + 1, y)
neighbour (x,y) Up'    = (x, y - 1)
neighbour (x,y) Down'  = (x, y + 1)

neighbours :: Position -> Board -> [(Position, Value)]
neighbours pos board = [ (p,v) | (p,v) <- board, inList p [neighbour pos Left', neighbour pos Right', neighbour pos Up', neighbour pos Down'] ]

solve :: Board -> Bones -> Result -> Solution
solve input [] output = Solved output
solve input (b:bs) output = Move input (b:bs) output [ solve input' bs output' | (input', output') <- possibleMoves input b output ]

possibleMoves :: Board -> Bone -> Result -> [(Board,Result)]
possibleMoves input piece output = []

--validPlace :: Bone -> (Position,Value) -> (Position,Value) -> Bool
--validPlace bone (_, Maybe val1) (_, Maybe val2) = pip1 bone == val1 && pip2 bone == val2
--validPlace _ _ _ = False

validPlace :: Board -> Bone -> (Position,Position) -> Bool
validPlace board stone (pos1,pos2) = int (findValue pos1 board) == pip1 stone && int (findValue pos2 board) == pip2 stone

placePiece :: Board -> Bone -> (Position,Position) -> Result -> (Board, Result)
placePiece input piece (pos1,pos2) output | (any (\x -> x == Empty) . map (\x -> findValue x input)) [pos1,pos2] = error "One of the positions not (free) on board."
                                          | int (findValue pos1 input) /= pip1 piece || int (findValue pos2 input) /= pip2 piece = error "Not a valid position."

getValue :: [Value] -> Value
getValue []  = Empty
getValue [x] = x

findValue :: Position -> Board -> Value
findValue pos board = getValue [ b | (p,b) <- board, p == pos ]

removePositions :: (Position,Position) -> Board -> Board
removePositions (p1,p2) board = [ (p,b) | (p,b) <- board, p /= p1 && p /= p2 ]

addBone :: Bone -> Result -> (Position,Position) -> Result
addBone b res (p1,p2) = (p1,b) : (p2,b) : res
