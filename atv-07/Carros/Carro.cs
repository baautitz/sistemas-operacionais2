namespace Carros;
internal class Carro {

	private readonly int _maxTurns;
	private bool _isRiding;

	public int CarNumber { get; }
	public int Speed { get; set; }
	public int Turn { get; set; }
	public DateTime? StartTime { get; private set; }
	public DateTime? StopTime { get; set; }

	public Carro(int carNumber, int maxTurns, int speed) {
		_maxTurns = maxTurns;

		Speed = speed;
		CarNumber = carNumber;
	}

	/**
	 * 1 - Se carro está parado
	 * 2 - Se carro está correndo
	 * 3 - Se carro finalizou a corrida
	 */
	public int GetStaus() {
		if (!_isRiding && StopTime == null) return 1;
		if (_isRiding) return 2;
		if (!_isRiding && StopTime != null) return 3;

		return -1;
	}

	public void Start() {
		if (_isRiding) return;

		_isRiding = true;
		StartTime = DateTime.Now;
		for (int i = 0; i < _maxTurns; i++) {
			Thread.Sleep(Speed);
			Turn++;
		}

		_isRiding = false;
		StopTime = DateTime.Now;
	}


}
