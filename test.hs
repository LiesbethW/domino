import Domino
import Bone
import Test.QuickCheck


test = do
  quickCheck(testNumber)

-- Bone
testNumber :: Int -> Int -> Int -> Bool
testNumber = (\x y z-> number (newBone x y z)  == x)

