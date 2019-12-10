module Part2 where

import Debug.Trace
import Data.List
import Machine

part1 :: [Int] -> [Int] -> [Int] -> Int
part1 _ [] x = (head x)
part1 values setting input = part1
    values
    (tail setting)
    (output (evaluate (Machine values [(head setting), (head input)] [] 0)))

appendOut :: Machine -> Machine -> Machine
appendOut x y = Machine (values x) ((inputs x) ++ [(last (outputs y))]) (outputs x) (pos x)

metaEvaluate :: [Machine] -> Int -> MachineOutput
metaEvaluate machines active =
    let machine = (machines!!active) in
    -- trace (show (machines, active))
    (case (op machine) of
        1 -> metaEvaluate (replaceNth active (opcode_1 machine) machines) active
        2 -> metaEvaluate (replaceNth active (opcode_2 machine) machines) active
        3 -> metaEvaluate (replaceNth active (opcode_3 machine) machines) active
        4 -> let out = (opcode_4 machine) in
            let next = (mod (active + 1) 5) in
            metaEvaluate
            (replaceNth
                next
                (appendOut (machines!!next) out)
                (replaceNth active out machines))
            next
        5 -> metaEvaluate (replaceNth active (opcode_5 machine) machines) active
        6 -> metaEvaluate (replaceNth active (opcode_6 machine) machines) active
        7 -> metaEvaluate (replaceNth active (opcode_7 machine) machines) active
        8 -> metaEvaluate (replaceNth active (opcode_8 machine) machines) active
        99 -> case active of
            4 -> opcode_99 machine
            _ -> metaEvaluate machines (mod (active + 1) 5)
        _ -> MachineOutput [] 0)

getMachines :: [Int] -> [Int] -> [Machine]
getMachines values settings = [
        Machine values [(settings!!0), 0] [] 0,
        Machine values [settings!!1] [] 0,
        Machine values [settings!!2] [] 0,
        Machine values [settings!!3] [] 0,
        Machine values [settings!!4] [] 0
    ]

calculate :: [Int] -> [Int] -> Int
calculate values settings = last (output (metaEvaluate (getMachines values settings) 0))

main = do
    line <- getLine
    let values = parseLine line :: [Int]

    putStrLn (show (maximum (map (\x -> calculate values x) (permutations [5, 6, 7, 8, 9]))))
