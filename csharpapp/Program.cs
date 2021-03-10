using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace csharpapp
{
    class Program
    {
        public const string fftComputeDll = @"..\Release\FFTProj.dll";

        [DllImport(fftComputeDll, CallingConvention = CallingConvention.Cdecl)]
        public static extern unsafe float** computeFFT(float* numbers, int size);

        public static unsafe float** computeFFTusingCUDA(float[] numbers, int arraySize)
        {

            unsafe
            {
                fixed (float* n = numbers)
                {
                    return computeFFT(n, arraySize);
                    
                }
            }
        }

        static void Main(string[] args)
        {
            int arraySize = 1000000;
            float[] numbers = new float[arraySize];
            var randomGenerator = new Random();

            for (int i = 0; i < arraySize; i++)
            {
                numbers[i] = randomGenerator.Next(1, arraySize);
            }

            var watch = new System.Diagnostics.Stopwatch();
            watch.Start();

            unsafe
            {
                float** output = computeFFTusingCUDA(numbers, arraySize);
            }

            watch.Stop();

            Console.WriteLine($"Execution Time: {watch.ElapsedMilliseconds} ms");
            Console.Read();
        }
    }
}
