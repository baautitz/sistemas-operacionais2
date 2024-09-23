namespace Carros;
internal class Interface {
	
	public void ClearScreen() {
		Console.Clear();
	}

	public void LoadScreen(Game game) {
		Console.SetCursorPosition(0, 0);
		Console.CursorVisible = false;

		string gameStatusString = "Não iniciada";
		if (game.GetStatus() == 2) gameStatusString = "Corrida em adamento"; 
		if (game.GetStatus() == 3) gameStatusString = "Corrida finalizada!";

		Console.WriteLine($"Status da corrida: {gameStatusString}");
		Console.WriteLine($"Total de carros: {game.NumberOfCars}");
		Console.WriteLine($"Carros correndo: {game.GetNumberOfRunningCars()}");
		Console.WriteLine($"Carros finalizados: {game.GetNumberOfFinishedCars()}");
		Console.WriteLine("");
		Console.WriteLine($"Horário: {DateTime.Now.ToString("hh:mm:ss:FF")}");
		Console.WriteLine("");
		foreach(Carro carro in game.Cars) {
			string? finishedTime = carro.GetStaus() == 3 ? carro.StopTime?.ToString("hh:mm:ss:ff") : "";
			string turns = "";
			for (int i = 0; i < carro.Turn; i++) {
				turns += $"{i + 1} ";
			}
			string carInfo = $"Carro {carro.CarNumber.ToString("D2")} - {(1000 - carro.Speed).ToString("D2")}km/h: ";
			carInfo += $"{turns} ";
			carInfo += $"{carro.StartTime?.ToString("hh:mm:ss:ff")} ";
			carInfo += $"{(game.GetWinner()?.CarNumber == carro.CarNumber ? finishedTime : "")} ";

			Console.WriteLine(carInfo);
		}
	}

	public void PrintGameResult(Game game) {
		Carro? winner = game.GetWinner();

		Console.WriteLine($"\nCarro ganhador: {(winner != null ? winner.CarNumber : "Não há ganhador")}");
		Console.WriteLine("\nCorrida finalizada! Aperte qualquer tecla para finalizar.");
		Console.ReadLine();
	}

}
