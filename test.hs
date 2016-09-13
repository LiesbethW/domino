import Domino
import Bone
import Test.QuickCheck


test = do
  quickCheck(testNumber)

-- Bone
testNumber :: Int -> Int -> Int -> Bool
testNumber = (\x y z-> number (bone x y z)  == x)

