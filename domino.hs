module Domino where
import Bone
import Board
import HelpWithMath
import Print

board2 = boardFromValues 2 [0,0,0,1,1,1,2,1,0,2,2,2]

tryadd = addBone (bone 1 0 0) [] (pos 1 1, pos 1 2)
