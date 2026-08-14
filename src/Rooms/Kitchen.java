package Rooms;

import Game.Runner;
import People.Person;

public class Kitchen extends Room{

    public Kitchen(int x, int y){
        super(x, y);

    }

    public void enterRoom(Person x){

        occupant = x;
        x.setxLoc(this.xLoc);
        x.setyLoc(this.yLoc);
        System.out.println("You are in the kitchen. The food here smells weeks old...");
    }
    public void leaveRoom(Person x)
    {
        occupant = x;
        occupant = null;
    }
}
