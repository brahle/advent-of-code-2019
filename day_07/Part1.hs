module Part1 where

import Data.List
import Machine (parseLine, Machine(..), evaluate, printOutput, output, resulting_opcode)

part1 :: [Int] -> [Int] -> [Int] -> Int
part1 _ [] x = (head x)
part1 values setting input = part1
    values
    (tail setting)
    (output (evaluate (Machine values [(head setting), (head input)] [] 0)))

main = do
    line <- getLine
    let values = parseLine line :: [Int]

    putStrLn (show (maximum (map (\x -> part1 values x [0]) (permutations [0, 1, 2, 3, 4]))))
