namespace Threads;

class Program {
	static void Main(string[] args) {
		Thread thread1 = new Thread(new ThreadStart(ImprimirNumeros));
		Thread thread2 = new Thread(new ThreadStart(ImprimirLetras));

		thread1.Start();
		thread2.Start();

		thread1.Join();
		thread2.Join();
	}

	static void ImprimirNumeros() {
		for (int i = 0; i < 5; i++) {
			Console.WriteLine($"Thread 1 - {i + 1}");
			Thread.Sleep(1000);
		}
	}

	static void ImprimirLetras() {
		for (int i = 0; i < 5; i++) {
			Console.WriteLine($"Thread 2 - {(char) (65 + i)}");
			Thread.Sleep(800);
		}
	}
}

