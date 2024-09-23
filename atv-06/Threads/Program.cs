using System.Net.Http.Headers;

namespace Threads;

class Program {
	static void Main(string[] args) {
		//Thread thread1 = new Thread(new ThreadStart(ImprimirNumeros));
		//Thread thread2 = new Thread(new ThreadStart(ImprimirLetras));

		//thread1.Start();
		//thread2.Start();

		//thread1.Join();
		//thread2.Join();

		Console.Write("Digite a quantidade de Threads: ");

		string? qtdeThreadsString = Console.ReadLine();
		int qtdeThreads = 0;

		int.TryParse(qtdeThreadsString, out qtdeThreads);

		if (qtdeThreads <= 0) {
			Console.WriteLine("Quantidade de Threads deve ser maior que 0.");
			return;
		}

		Console.Write("Digite o numero a ser fatoriado: ");

		string? numeroFatorialString = Console.ReadLine();
		int numeroFatorial = 0;

		int.TryParse(numeroFatorialString, out numeroFatorial);

		if (numeroFatorial <= 0) {
			Console.WriteLine("Quantidade de Threads deve ser maior que 0.");
			return;
		}

		for (int i = 0; i < qtdeThreads; i++) {
			int threadId = i + 1;

			Thread thread = new(() => Fatorial(threadId, numeroFatorial));
			thread.Start();
		}
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

	static void ContarNumeros(int id) {
		for (int i = 0; i < 1000; i++) {
			Console.WriteLine($"Thread {id} - {i + 1}");
		}
	}

	static void Fatorial(int id, int valor) {
		long res = 1;

		for (int i = 1; i <= valor; i++) {
			res = res * i;
			Console.WriteLine($"Thread {id} - Fatorial: {res} ({i} de {valor})");
		}
	}
}
