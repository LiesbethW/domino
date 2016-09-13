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
data Position = Pos (Int, Int)
pos_x :: Position -> Int
pos_x (Pos (x,_)) = x

pos_y :: Position -> Int
pos_y (Pos (_,y)) = y

instance Eq Position where
  (Pos (x,y)) == (Pos (u,v)) = (x == u) && (y == v)

instance Show Position where
  show (Pos t) = show t

-- Board
type Board = [(Position, Value)]

-- Result
type Result = [(Position, Bone)]

positions :: Int -> [Position]
positions n = [ Pos (x,y) | x <- [1..(n+2)], y <- [1..(n+1)] ]

emptyBoard :: Int -> Board
emptyBoard n = zip (positions n) (repeat Empty)

boardFromValues :: Int -> [Int] -> Board
boardFromValues n values | (length values) /= (length (positions n)) = error "Provide exactly as many values as fit the board"
                         | otherwise = zip (positions n) [ Maybe x | x <- values ]

data Solution = Move Board Bones Result [Solution] | Solved Result | GameOver

data Side = Left' | Right' | Up' | Down'

neighbour :: Position -> Side -> Position
neighbour (Pos (x,y)) Left'  = Pos (x - 1, y)
neighbour (Pos (x,y)) Right' = Pos (x + 1, y)
neighbour (Pos (x,y)) Up'    = Pos (x, y - 1)
neighbour (Pos (x,y)) Down'  = Pos (x, y + 1)

neighbours :: Position -> Board -> [(Position, Value)]
neighbours pos board = [ (p,v) | (p,v) <- board, inList p [neighbour pos Left', neighbour pos Right', neighbour pos Up', neighbour pos Down'] ]

solve :: Board -> Bones -> Result -> Solution
solve input [] output = Solved output
solve input (b:bs) output = Move input (b:bs) output [ solve input' bs output' | (input', output') <- possibleMoves input b output ]

possibleMoves :: Board -> Bone -> Result -> [(Board,Result)]
possibleMoves input piece output = []

validPlace :: Bone -> (Position,Value) -> (Position,Value) -> Bool
validPlace bone (_, Maybe val1) (_, Maybe val2) = pip1 bone == val1 && pip2 bone == val2
validPlace _ _ _ = False

placePiece :: Board -> Bone -> (Position,Position) -> Result -> (Board, Result)
placePiece input piece (pos1,pos2) output | (any (\x -> x == Empty) . map (\x -> findValue x input)) [pos1,pos2] = error "One of the positions not (free) on board."
                                          | int (findValue pos1 input) /= pip1 piece || int (findValue pos2 input) /= pip2 piece = error "Not a valid position."

getValue :: [Value] -> Value
getValue []  = Empty
getValue [x] = x

findValue :: Position -> Board -> Value
findValue pos board = getValue [ b | (p,b) <- board, p == pos ]

removePosition :: Position -> Board -> Board
removePosition pos board = [ (p,b) | (p,b) <- board, p /= pos ]
