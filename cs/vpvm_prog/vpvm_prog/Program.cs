using System;
using System.IO.Ports;
using System.IO;

namespace vpvm_prog
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                Console.WriteLine("Usage: prg COM<number> <filename>");
                Console.Write("Serial ports list: (");
                foreach (string s in SerialPort.GetPortNames())
                {
                    Console.Write("{0} ", s);
                }
                Console.WriteLine(")");
                return;
            }

            Console.WriteLine("{0}, 9600 baud, no parity bits, 8 data bits, 1 stop bit", args[0]);
            Console.WriteLine(args[1]);

            FileStream fileStream = new FileStream(args[1], FileMode.Open);
            byte[] writeBuffer = new byte[256];
            fileStream.Read(writeBuffer, 0, writeBuffer.Length);
            for (int i = 0; i < 16; ++i)
            {
                for (int j = 0; j < 16; ++j)
                {
                    Console.Write("{0,4}", writeBuffer[j + i * 16].ToString());
                }
                Console.WriteLine();
            }

            SerialPort serialPort = new SerialPort(args[0], 9600, Parity.None, 8, StopBits.One);
            try
            {
                serialPort.Open();
            }
            catch (IOException e)
            {
                Console.WriteLine(e.Message);
                return;
            }
            serialPort.Write(writeBuffer, 0, writeBuffer.Length);
            serialPort.Close();
        }
    }
}
