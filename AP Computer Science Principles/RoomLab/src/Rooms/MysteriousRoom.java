package Rooms;

import Game.Board;
import People.Person;
import People.Criminal;

public class MysteriousRoom extends Room{

    public MysteriousRoom(int x, int y, int enemy){
        super(x, y, enemy);

    }

    public void enterRoom(Person x){

        occupant = x;
        x.setxLoc(this.xLoc);
        x.setyLoc(this.yLoc);
        System.out.println("You are in a mysterious room. You can feel someone watching you...");
        if(enemy==1) {
            System.out.println("You hear the sound of a criminal. You turn around as he pulls out a ...");
            System.out.println("\033Quick, do something! You can sidestep, backpedal, or reach for the armor on the table.\033");
            Criminal enemy = Board.placeEnemy(1);
            Board.combat(x, enemy);
        }
        else{
            System.out.println("You could swear you heard something, but you move on...");
        }
    }
    public void leaveRoom(Person x)
    {
        occupant = x;
        occupant = null;
    }
}
