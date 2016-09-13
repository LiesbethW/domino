module HelpWithMath where

faculty :: Int -> Int
faculty 0 = 1
faculty n = n * faculty (n - 1)

triangular :: Int -> Int
triangular n = (n * (n + 1) `div` 2)

inList :: Eq a => a -> [a] -> Bool
inList a []     = False
inList a (x:xs) = (a == x) || inList a xs

find :: Eq a => a -> [(a,b)] -> [b]
find x tuples = [ b | (a,b) <- tuples, a == x ]

remove :: Eq a => a -> [(a,b)] -> [(a,b)]
remove x tuples = [ (a,b) | (a,b) <- tuples, a /= x ]

--- Chopping
-- Unfold
unfold :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> [b]
unfold p h t x | p x       = []
               | otherwise = h x : unfold p h t (t x)

chop :: Int -> [a] -> [[a]]
chop n = unfold null (take n) (drop n)
