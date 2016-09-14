module Bone where
import HelpWithMath

type Bone = (Int, (Int,Int))

newBone :: Int -> Int -> Int -> Bone
newBone x y z = (x, (y,z))

number :: Bone -> Int
number (n, _) = n

pips :: Bone -> (Int,Int)
pips (_,p) = p

pip1 :: Bone -> Int
pip1 (_,(a,_)) = a

pip2 :: Bone -> Int
pip2 (_,(_,b)) = b

type Bones = [Bone]

  --instance Show Bone where
  --  show b = ((show . pip1) b) ++ "|" ++ ((show . pip2) b)

newBones :: Int -> Bones
newBones n = zip [1..(triangular (n + 1))] [ (a,b) | a <- [0..n], b <- [a..n]]
