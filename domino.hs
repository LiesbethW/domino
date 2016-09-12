import Print
import Bone
import HelpWithMath

dominos :: Int -> [(Int, Bone)]
dominos n = zip [1..(triangular (n + 1))] [ Piece (a,b) | a <- [0..n], b <- [a..n]]
