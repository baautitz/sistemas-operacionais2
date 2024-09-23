namespace Carros;

internal class Program {
	static void Main(string[] args) {
		Console.Write("Digite o número de carros: ");
		string numberOfCarsString = Console.ReadLine() ?? " ";

		Console.Write("Digite o número de voltas: ");
		string numberOfTurnsString = Console.ReadLine() ?? " ";

		int numberOfCars;
		int numberOfTurns;

		int.TryParse(numberOfCarsString, out numberOfCars);
		int.TryParse(numberOfTurnsString, out numberOfTurns);

		Game game = new Game(numberOfCars, numberOfTurns);
		Interface aInterface = new Interface();

		new Thread(game.Start).Start();
		new Thread(() => {
			aInterface.ClearScreen();

			while (game.GetNumberOfRunningCars() != 0) {
				aInterface.LoadScreen(game);
			}

			Thread.Sleep(1000);
			aInterface.LoadScreen(game);
			aInterface.PrintGameResult(game);
		}).Start();

	}
}
