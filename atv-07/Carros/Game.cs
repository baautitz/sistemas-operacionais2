namespace Carros;
internal class Game {

	private List<Carro> _cars { get; } = new List<Carro>();

	public int NumberOfCars { get; }
	public int MaxTurns { get; }

	public Game(int numberOfCars, int maxTurns) {
		NumberOfCars = numberOfCars;
		MaxTurns = maxTurns;
	}

	public int GetNumberOfStoppedCars() {
		return _cars.FindAll(c => c.GetStaus() == 1).Count;
	}

	public int GetNumberOfRunningCars() {
		return _cars.FindAll(c => c.GetStaus() == 2).Count;
	}

	public int GetNumberOfFinishedCars() {
		return _cars.FindAll(c => c.GetStaus() == 3).Count;
	}

	/**
	 * 1 - Se carrida não iniciou
	 * 2 - Se corrida iniciou
	 * 3 - Se carrida finalizada
	 */
	public int GetStatus() {
		if (GetNumberOfFinishedCars() == 0 && GetNumberOfRunningCars() == 0) return 1;
		if (GetNumberOfStoppedCars() == 0 && GetNumberOfRunningCars() != 0) return 2;
		if (GetNumberOfStoppedCars() == 0 && GetNumberOfRunningCars() == 0) return 3;

		return -1;
	}

	public Carro? GetWinner() {
		List<Carro> stoppedCars = Cars.FindAll(c => c.GetStaus() == 3).OrderBy(c => c.StopTime).ToList();

		if (stoppedCars == null || stoppedCars.Count == 0)
			return null;


		return stoppedCars[0];
	}

	public void Start() {
		Random random = new Random();

		for (int i = 0; i < NumberOfCars; i++) {
			int carID = i + 1;
			int carSpeed = random.Next(900, 1001);

			new Thread(() => {
				Carro carro = new Carro(carID, MaxTurns, carSpeed);
				_cars.Add(carro);
				carro.Start();
			}).Start();
		}
	}

	public List<Carro> Cars {
		get {
			return _cars.OrderBy(c => c.CarNumber).ToList();
		}
	}
}
