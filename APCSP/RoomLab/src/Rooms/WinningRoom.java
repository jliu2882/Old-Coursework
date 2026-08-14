package Rooms;

import Game.Runner;
import People.Person;

public class WinningRoom extends Room {

	public WinningRoom(int x, int y) {
		super(x, y);

	}

	/**
	 * Triggers the game ending conditions.
	 * @param x the Person entering
	 */
	@Override
	public void enterRoom(Person x) {

		occupant = x;
		x.setxLoc(this.xLoc);
		x.setyLoc(this.yLoc);
		Runner.gameOff();
		System.out.println("You found the hostage. Well done!");
	}
	public void leaveRoom(Person x)
	{
		occupant = x;
		occupant = null;
	}

}
