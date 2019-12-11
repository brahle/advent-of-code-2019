using System;
using System.Collections.Generic;
using System.Text;
using System.Numerics;

namespace Day09
{
    class Machine
    {
        public BigInteger Position { get; set; }
        public BigInteger RelativeIndex { get; set; }
        public Dictionary<BigInteger, BigInteger> Memory { get; set; }
        public Queue<BigInteger> Inputs;
        public delegate void OutputF(BigInteger value);
        public OutputF Output { get; set; }

        public Machine()
        {
            Position = 0;
            RelativeIndex = 0;
            Inputs = new Queue<BigInteger>();
            Output = (x) => System.Console.WriteLine("OUTPUT: " + x);
            Memory = new Dictionary<BigInteger, BigInteger>();
        }

        public Machine(String values, String inputs) : this()
        {
            BigInteger[] tmp = Array.ConvertAll(values.Split(","), BigInteger.Parse);
            for (int i = 0; i < tmp.Length; ++i)
            {
                Memory[i] = tmp[i];
            }
            if (inputs.Length > 0)
            {
                Inputs = new Queue<BigInteger>(Array.ConvertAll(inputs.Split(","), BigInteger.Parse));
            }
        }

        public void Evaluate()
        {
            while (EvaluateNext())
            {
            }
        }

        public bool EvaluateNext()
        {
            switch (op())
            {
                case 1: return Opcode1();
                case 2: return Opcode2();
                case 3: return Opcode3();
                case 4: return Opcode4();
                case 5: return Opcode5();
                case 6: return Opcode6();
                case 7: return Opcode7();
                case 8: return Opcode8();
                case 9: return Opcode9();
                case 99: return Opcode99();
                default:
                    throw new Exception("Not implemented opcode " + op().ToString());
            }
        }

        public int op()
        {
            return (int)(Memory[Position] % 100);
        }

        public bool Opcode1()
        {
            Write(3, Resolve(1) + Resolve(2));
            Position += 4;
            return true;
        }

        public bool Opcode2()
        {
            Write(3, Resolve(1) * Resolve(2));
            Position += 4;
            return true;
        }

        public bool Opcode3()
        {
            Write(1, Inputs.Dequeue());
            Position += 2;
            return true;
        }

        public bool Opcode4()
        {
            Output(Resolve(1));
            Position += 2;
            return true;
        }

        public bool Opcode5()
        {
            if (Resolve(1) != 0)
            {
                Position = Resolve(2);
            }
            else
            {
                Position += 3;
            }
            return true;
        }

        public bool Opcode6()
        {
            if (Resolve(1) == 0)
            {
                Position = Resolve(2);
            }
            else
            {
                Position += 3;
            }
            return true;
        }

        public bool Opcode7()
        {
            if (Resolve(1) < Resolve(2))
            {
               Write(3, 1);
            }
            else
            {
                Write(3, 0);
            }
            Position += 4;
            return true;
        }

        public bool Opcode8()
        {
            if (Resolve(1) == Resolve(2))
            {
                Write(3, 1);
            }
            else
            {
                Write(3, 0);
            }
            Position += 4;
            return true;
        }

        public bool Opcode9()
        {
            RelativeIndex += Resolve(1);
            Position += 2;
            return true;
        }

        public bool Opcode99()
        {
            Console.WriteLine("DONE " + Memory[0]);
            return false;
        }

        private BigInteger Resolve(int index)
        {
            BigInteger opcode = Memory[Position];
            switch (mode(opcode, index))
            {
                case 0: return Positional(index);
                case 1: return Immediate(index);
                case 2: return Relative(index);
                default:
                    break;
            }
            throw new Exception("Faulty opcode " + opcode.ToString());
        }

        private BigInteger Positional(int index)
        {
            return Read(Memory[Position + index]);
        }

        private BigInteger Immediate(int index)
        {
            return Read(Position + index);
        }

        private BigInteger Relative(int index)
        {
            return Read(RelativeIndex + Memory[Position + index]);
        }

        private BigInteger Read(BigInteger x)
        {
            BigInteger ret;
            if (Memory.TryGetValue(x, out ret))
            {
                return ret;
            }
            return 0;
        }

        private void Write(int index, BigInteger value)
        {
            Memory[GetWriteIndex(index)] = value;
        }

        private BigInteger GetWriteIndex(int index)
        {
            switch (mode(Memory[Position], index))
            {
                case 0: return Read(Position + index);
                case 2: return Read(Position + index) + RelativeIndex;
                default:
                    throw new Exception("Unexpected write mode " + Memory[Position].ToString());
            }
        }

        private int mode(BigInteger opcode, int index)
        {
            if (index == 1)
            {
                return (int)(opcode / 100 % 10);
            }
            if (index == 2)
            {
                return (int)(opcode / 1000 % 10);
            }
            if (index == 3)
            {
                return (int)(opcode / 10000 % 10);
            }
            return (int)(opcode / 100000 % 10);
        }
    }
}
