package Rooms;

import Game.Runner;
import People.Person;

public class Bathroom extends Room {
    public Bathroom(int x, int y){
        super(x, y);

    }

    public void enterRoom(Person x){

        occupant = x;
        x.setxLoc(this.xLoc);
        x.setyLoc(this.yLoc);
        System.out.println("You are in the bathroom. Someone left the sink running...");
    }
    public void leaveRoom(Person x)
    {
        occupant = x;
        occupant = null;
    }
}
