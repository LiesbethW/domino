module Bone where
import HelpWithMath

type Pips = Int

data Bone = Piece (Pips,Pips)

instance Show Bone where
  show (Piece m) =  (show (fst m)) ++ "|" ++ (show (snd m))

bones :: Int -> [(Int, Bone)]
bones n = zip [1..(triangular (n + 1))] [ Piece (a,b) | a <- [0..n], b <- [a..n]]
