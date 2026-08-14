package Rooms;

import Game.Runner;
import People.Person;

public class LivingRoom extends Room {
    public LivingRoom(int x, int y){
        super(x, y);

    }

    public void enterRoom(Person x){

        occupant = x;
        x.setxLoc(this.xLoc);
        x.setyLoc(this.yLoc);
        System.out.println("You are in the living room. The TV seems to be playing static...");
    }
    public void leaveRoom(Person x)
    {
        occupant = x;
        occupant = null;
    }
}