using System;
using System.Threading.Tasks;

Console.WriteLine("Hello World!");

await Task.Delay(5 * 60 * 1000);

Console.WriteLine("Finished");