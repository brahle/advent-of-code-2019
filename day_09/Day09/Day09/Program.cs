using System;
using System.Collections.Generic;
using System.Numerics;

namespace Day09
{
    class Program
    {
        static void Main(string[] args)
        {
            Machine m = ReadMachine();
            m.Evaluate();
        }

        private static Machine ReadMachine()
        {
            String values = Console.ReadLine();
            String inputs = Console.ReadLine();
            return new Machine(values, inputs);
        }
    }
}
