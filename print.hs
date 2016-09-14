module Print where
import Board
import HelpWithMath

-- Print a string to a line
printLn :: String -> IO ()
printLn input = putStrLn input

newLine :: IO()
newLine = putChar '\n'

printList :: Show a => [a] -> IO ()
printList [] = return ()
printList (x:xs) = do (putStr . show) x
                      putStr " "
                      printList xs

printListList :: Show a => [[a]] -> IO ()
printListList [] = return ()
printListList (x:xs) = do printList x
                          newLine
                          printListList xs

printBoard :: Board -> IO ()
printBoard board = do printLn "input"
                      (printListList . chop (width board) . map (\(p,v) -> v)) board

printResult :: Result -> IO ()
printResult result = do printLn "solution"
                        (printListList . chop (width result) . map (\(p,b) -> b)) result

printResultList :: [Result] -> IO ()
printResultList [] = printLn "There are no solutions"
printResultList (r:results) = do printResult r
                                 printResultList results
