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

remove :: Eq a => a -> [a] -> [a]
remove x list = [ a | a <- list, a /= x ]

--- Chopping
-- Unfold
unfold :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> [b]
unfold p h t x | p x       = []
               | otherwise = h x : unfold p h t (t x)

chop :: Int -> [a] -> [[a]]
chop n = unfold null (take n) (drop n)

-- Counting occurences
count n xs ys = all (\s -> s == n) (map (\x -> sum [ 1 | y <- ys, y == x ]) xs)

-- Unique elements (is 'nub': https://downloads.haskell.org/~ghc/6.12.1/docs/html/libraries/base-4.2.0.0/src/Data-List.html#nub)
uniq :: Eq a => [a] -> [a]
uniq list = uniq' list []
  where
    uniq' [] _  = []
    uniq' (x:xs) ls | x `elem` ls   = uniq' xs ls
                    | otherwise     = x : uniq' xs (x:ls)
