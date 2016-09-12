module HelpWithMath where

faculty :: Int -> Int
faculty 0 = 1
faculty n = n * faculty (n - 1)

triangular :: Int -> Int
triangular n = (n * (n + 1) `div` 2)
