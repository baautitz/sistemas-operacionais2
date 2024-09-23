using System.Diagnostics;

namespace LockThreads;

internal class Program {
	
	static int contador = 1;
	static readonly object lockObj = new object();

	static void IncrementaContador(int id) {
		for (int i = 0; i < 1000; i++) {
			lock(lockObj) {
				Console.WriteLine($"Thread {id} - {contador}");
				contador++;
				Thread.Sleep(5);
			}
		}
	}
	static void Main(string[] args) {
		new Thread(() => IncrementaContador(1)).Start();
		new Thread(() => IncrementaContador(2)).Start();
	}

	
}


