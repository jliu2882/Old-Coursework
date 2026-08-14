package Rooms;

import Game.Runner;
import People.Person;

public class Bedroom extends Room{

    public Bedroom(int x, int y){
        super(x, y);

    }

    public void enterRoom(Person x){

        occupant = x;
        x.setxLoc(this.xLoc);
        x.setyLoc(this.yLoc);
        System.out.println("You are in the bedroom. Everything looks in order here...");
    }
    public void leaveRoom(Person x)
    {
        occupant = x;
        occupant = null;
    }
}
