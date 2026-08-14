package Rooms;

import People.Person;

public abstract class Room {
	Person occupant;
	int xLoc,yLoc,enemy;

	public Room(int x, int y)
	{
		xLoc = x;
		yLoc = y;
	}
	public Room(int x, int y, int enemyInt)
	{
		xLoc = x;
		yLoc = y;
		enemy = enemyInt;
	}

	/**
	 * Method controls the results when a person enters this room.
	 * @param x the Person entering
	 */
	public void enterRoom(Person x)
	{
		System.out.println("You enter a plain old room");
		occupant = x;
		x.setxLoc(this.xLoc);
		x.setyLoc(this.yLoc);
	}

	/**
	 * Removes the player from the room.
	 * @param x
	 */
	public void leaveRoom(Person x)
	{
		occupant = x;
		occupant = null;
	}

}
