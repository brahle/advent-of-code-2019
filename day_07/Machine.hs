module Machine (
    parseLine,
    Machine(..),
    MachineOutput(..),
    evaluate,
    printOutput,
    op,
    opcode_1,
    opcode_2,
    opcode_3,
    opcode_4,
    opcode_5,
    opcode_6,
    opcode_7,
    opcode_8,
    opcode_99,
    replaceNth
) where

import Data.Array.IO
import Debug.Trace
-- import Data.List.Split

data Machine = Machine {
    values :: [Int],
    inputs :: [Int],
    outputs :: [Int],
    pos :: Int
} deriving (Show)

split :: String -> [String]
split [] = [""]
split (c:cs) | c == ',' = "" : rest
             | otherwise = (c : head rest) : tail rest
    where rest = split cs

parseLine :: String -> [Int]
parseLine "" = []
parseLine line = map read (split line)

data MachineOutput = MachineOutput {
    output :: [Int],
    resulting_opcode :: Int
} deriving (Show)

opcode :: Machine -> Int
opcode m = ((values m)!!(pos m))

op :: Machine -> Int
op m = (mod (opcode m) 100)

position :: Machine -> Int -> Int
position m x = ((values m)!!x)

immediate :: Machine -> Int -> Int
immediate m x = x

mode :: Machine -> Int -> Int
mode m 1 = (mod (div (opcode m) 100) 10)
mode m 2 = (mod (div (opcode m) 1000) 10)
mode m 3 = (mod (div (opcode m) 10000) 10)

param :: Machine -> Int -> Int
param m idx = ((values m)!!((pos m) + idx))

resolve :: Machine -> Int -> Int
resolve m idx = case (mode m idx) of
    0 -> position m (param m idx)
    1 -> immediate m (param m idx)

replaceNth :: Int -> a -> [a] -> [a]
replaceNth _ _ [] = []
replaceNth n newVal (x:xs)
    | n == 0 = newVal:xs
    | otherwise = x:replaceNth (n-1) newVal xs

opcode_1_values :: Machine -> [Int]
opcode_1_values m = replaceNth (param m 3) ((resolve m 1) + (resolve m 2)) (values m)

opcode_1 :: Machine -> Machine
opcode_1 m = (Machine (opcode_1_values m) (inputs m) (outputs m) ((pos m) + 4))

opcode_2_values :: Machine -> [Int]
opcode_2_values m = replaceNth (param m 3) ((resolve m 1) * (resolve m 2)) (values m)

opcode_2 :: Machine -> Machine
opcode_2 m = (Machine (opcode_2_values m) (inputs m) (outputs m) ((pos m) + 4))

opcode_3_values :: Machine -> [Int]
opcode_3_values m = replaceNth (param m 1) ((inputs m)!!0) (values m)

opcode_3 :: Machine -> Machine
opcode_3 m = (Machine (opcode_3_values m) (drop 1 (inputs m)) (outputs m) ((pos m) + 2))

opcode_4 :: Machine -> Machine
opcode_4 m = (Machine (values m) (inputs m) ((outputs m) ++ [resolve m 1]) ((pos m) + 2))

opcode_5_pos :: Machine -> Int
opcode_5_pos m = case (resolve m 1) of
    0 -> (pos m) + 3
    _ -> resolve m 2

opcode_5 :: Machine -> Machine
opcode_5 m = (Machine (values m) (inputs m) (outputs m) (opcode_5_pos m))

opcode_6_pos :: Machine -> Int
opcode_6_pos m = case (resolve m 1) of
    0 -> resolve m 2
    _ -> (pos m) + 3

opcode_6 :: Machine -> Machine
opcode_6 m = (Machine (values m) (inputs m) (outputs m) (opcode_6_pos m))

opcode_7_values :: Machine -> [Int]
opcode_7_values m = replaceNth
    (param m 3)
    (if (resolve m 1) < (resolve m 2) then 1 else 0)
    (values m)

opcode_7 :: Machine -> Machine
opcode_7 m = (Machine (opcode_7_values m) (inputs m) (outputs m) ((pos m) + 4))

opcode_8_values :: Machine -> [Int]
opcode_8_values m = replaceNth
    (param m 3)
    (if ((resolve m 1) == (resolve m 2)) then 1 else 0)
    (values m)

opcode_8 :: Machine -> Machine
opcode_8 m = (Machine (opcode_8_values m) (inputs m) (outputs m) ((pos m) + 4))

opcode_99 :: Machine -> MachineOutput
opcode_99 m = MachineOutput (outputs m) ((values m)!!0)

evaluate :: Machine -> MachineOutput
evaluate machine = (case (op machine) of
        1 -> evaluate (opcode_1 machine)
        2 -> evaluate (opcode_2 machine)
        3 -> evaluate (opcode_3 machine)
        4 -> evaluate (opcode_4 machine)
        5 -> evaluate (opcode_5 machine)
        6 -> evaluate (opcode_6 machine)
        7 -> evaluate (opcode_7 machine)
        8 -> evaluate (opcode_8 machine)
        99 -> opcode_99 machine
        _ -> MachineOutput [] 0)


printOutput :: Int -> IO ()
printOutput x = putStrLn ("OUTPUT: " ++ (show x))

main = do
    line <- getLine
    let values = parseLine line :: [Int]
    line <- getLine
    let inputs = parseLine line :: [Int]
    let machine = Machine values inputs [] 0
    let result = (evaluate machine)
    mapM_ printOutput (output result)
    putStrLn ("DONE " ++ (show (resulting_opcode result)))
