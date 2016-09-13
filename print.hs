module Print where
import Board
import HelpWithMath

-- Print a string to a line
printLn :: String -> IO ()
printLn input = putStrLn input

newLine :: IO()
newLine = putChar '\n'

printList :: [Int] -> IO ()
printList [] = return ()
printList (x:xs) = do (putStr . show) x
                      putStr " "
                      printList xs

printListList :: [[Int]] -> IO ()
printListList [] = return ()
printListList (x:xs) = do printList x
                          newLine
                          printListList xs

printBoard :: Board -> IO ()
printBoard board = do printLn "input"
                      (printListList . chop (board_y board) . map (\(p,v) -> int v)) board
