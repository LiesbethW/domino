module Print where

-- Print a string to a line
printLn :: String -> IO ()
printLn input = putStrLn input

newLine :: IO()
newLine = putChar '\n'

printList :: [Int] -> IO ()
printList [] = return ()
printList (x:xs) = do (putStr . show) x
                      printList xs
