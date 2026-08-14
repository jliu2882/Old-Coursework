package Game;

import People.Criminal;
import People.Grunt;
import People.Thief;
import Rooms.*;
import People.Person;

import java.util.Scanner;

/**
 * mixed up x and y coordinates but the code works fine
 * tried to implement different floors but ran out of time
 */

public class Board {
    private static int r;
    private static int c;
    private static int mem1;
    private static int mem2;
    private static int floorNum = 1;

    public Board(int r, int c) {
        this.r = r;
        this.c = c;
    }

    public static Room[][] setBuilding(){
        Room[][] building = new Room[r][c];

        //Fill the building with rooms
        for (int x = 0; x<building.length; x++)
        {
            for (int y = 0; y < building[x].length; y++)
            {
                int rand = (int)(Math.random()*5+1);
                if(rand==1){
                    building[x][y] = new Bedroom(x, y);
                }else if(rand==2){
                    building[x][y] = new Bathroom(x, y);
                }else if(rand==3){
                    building[x][y] = new Kitchen(x, y);
                }else if(rand==4){
                    building[x][y] = new MysteriousRoom(x, y, chanceSim(2));
                }else if(rand==5){
                    building[x][y] = new LivingRoom(x, y);
                }
            }
        }

        //Create a random winning room.
        int x = (int)(Math.random()*building.length);
        int y = (int)(Math.random()*building.length);
        building[x][y] = new WinningRoom(x, y);
        mem1 = x;
        mem2 = y;
        return building;
    }
    public static Criminal placeEnemy(){
        int x = mem1 + chanceSim(2);
        int y = mem2 + chanceSim(2);
        if(x>r){
            x=r;
        } else if(x<1){
            x=1;
        }
        if(y>c){
            y=c;
        } else if(y<1){
            y=1;
        }
        if(chanceSim(2)>0) {
            Grunt enemy1 = new Grunt("Strong","Criminal", x, y, floorNum);
            return enemy1;
        }
        else{
            Thief enemy1 = new Thief("Speedy", "Criminal", x, y, floorNum);
            return enemy1;
        }
    }
    public static Criminal placeEnemy(int type){
        int x = mem1 + chanceSim(2);
        int y = mem2 + chanceSim(2);
        if(x>r){
            x=r;
        } else if(x<1){
            x=1;
        }
        if(y>c){
            y=c;
        } else if(y<1){
            y=1;
        }
        if(type>0) {
            Thief enemy1 = new Thief("Speedy", "Criminal", x, y, floorNum);
            return enemy1;
        }
        else{
            Grunt enemy1 = new Grunt("Strong","Criminal", x, y, floorNum);
            return enemy1;
        }
    }
    public static int chanceSim(int n){
        int r = (int)(Math.random()*n);
        if(r==0){
            return -1;
        }
        return 1;
    }
    public static void printMap(Person p, Person p2, String init){
        int x = p.getxLoc();
        int y = p.getyLoc();
        int x2 = p2.getxLoc();
        int y2 = p2.getyLoc();

        String[][] map = new String[2*r+1][4*c+1];
        String finMap = "";
        for(int i =0; i < map.length; i++){
            if(i%2==0){
                for(int j= 0;j <map[i].length;j++){
                    map[i][j] = "-";
                }
            }
            else{
                for(int j =0; j<map[i].length;j++){
                    if(j%4==0){
                        map[i][j] = "|";
                    }
                    else{
                        map[i][j] = " ";
                    }
                }
            }
        }
        if(p2.getHP()>0) {
            map[2*x2 + 1][4*y2 + 2] = "\uD83D\uDC80";
        }
        map[2*x+1][4*y+2] = init.toUpperCase();
        for(String[] row : map){
            for(String column: row){
                finMap += column;
            }
            finMap += "\n";
        }
        System.out.println(finMap);
    }
    public static boolean validMove(String move, Person p, Room[][] map) {
        /**
         * Checks that the movement chosen is within the valid game map.
         * @param move the move chosen
         * @param p person moving
         * @param map the 2D array of rooms
         * @return
         */
        move = move.toLowerCase().trim();
        switch (move) {
            case "n":
                if (p.getxLoc() > 0)
                {
                    map[p.getxLoc()][p.getyLoc()].leaveRoom(p);
                    map[p.getxLoc()-1][p.getyLoc()].enterRoom(p);
                    return true;
                }
                else
                {
                    return false;
                }
            case "e":
                if (p.getyLoc()< map[p.getyLoc()].length -1)
                {
                    map[p.getxLoc()][p.getyLoc()].leaveRoom(p);
                    map[p.getxLoc()][p.getyLoc() + 1].enterRoom(p);
                    return true;
                }
                else
                {
                    return false;
                }

            case "s":
                if (p.getxLoc() < map.length - 1)
                {
                    map[p.getxLoc()][p.getyLoc()].leaveRoom(p);
                    map[p.getxLoc()+1][p.getyLoc()].enterRoom(p);
                    return true;
                }
                else
                {
                    return false;
                }

            case "w":
                if (p.getyLoc() > 0)
                {
                    map[p.getxLoc()][p.getyLoc()].leaveRoom(p);
                    map[p.getxLoc()][p.getyLoc()-1].enterRoom(p);
                    return true;
                }
                else
                {
                    return false;
                }


            default:
                break;

        }
        return true;
    }
    public static void combat(Person player, Person enemy){
        Scanner in = new Scanner(System.in);
        String defense = in.nextLine();
        if(defense.toLowerCase().contains("sidestep")){
            if(chanceSim(3)<0){
                System.out.println("... sword. You tried to sidestep, but his swing connects. Lose 1 hp.");
                player.loseHP(player);
            } else if(chanceSim(2)<0){
                System.out.println("... pistol. He shoots, but you step away swiftly.");
            } else{
                System.out.println("... rapier. He lunges at you, but you step to the side with ease.");
            }
        } else if(defense.toLowerCase().contains("backpedal")){
            if(chanceSim(3)<0){
                System.out.println("... pistol. You tried to back up, but he lands a shot. Lose 1 hp.");
                player.loseHP(player);
            } else if(chanceSim(2)<0){
                System.out.println("... rapier. He lunges at you, and misses you by an inch.");
            } else{
                System.out.println("... sword. He swings, misses, and lodges his sword into the wall.");
            }
        } else if(defense.toLowerCase().contains("armor")){
            if(chanceSim(3)<0){
                System.out.print("... rapier. You put on the flimsy armor, but the rapier cuts through. Lose 1 hp.");
                player.loseHP(player);
            } else if(chanceSim(2)<0){
                System.out.println("... sword. He swings, only to hit the tough chainmail.");
            } else{
                System.out.println("... pistol. He shoots, and the bullet is easily deflected. Time to strike back!");
            }
        } else{
            System.out.println("That wasn't an option. Please choose again!");
            combat(player,enemy);
        }
        System.out.println("The criminal seems to be ready for your next attack");
        System.out.println("You quickly reach into you pockets for any weapons. \n \033You have 4 pockets, which one do you go for?");
        String choice = in.nextLine();
        int offense = Integer.parseInt(choice);
        if(offense == 1){ 
            if(chanceSim(5)>0) {
                System.out.println("You pull out a gun, and get a clean shot. The criminal runs out of the building.");
                enemy.loseHP(enemy);
            } else {
                System.out.println("You pull out a gun, but you miss your shot. The criminal runs off.");
                enemy.loseHP(enemy);
            }
        }
        else if(offense == 2){
            System.out.println("You pull out your kitchen knife, and chase him. The criminal runs off.");
            enemy.loseHP(enemy);
        }
        else if(offense == 3){
            System.out.println("You pull out a bag of sand. You menacingly throw it at him, blinding him. He runs through a window, and is promptly caught and arrested by the police.");
            enemy.loseHP(enemy);
        }
        else if( offense == 4){
            System.out.println("You pull out absolutely nothing. \n You try to get away.");
            if(chanceSim(2)<0){
                player.setxLoc(0);
                player.setyLoc(0);
                System.out.println("You get away successfully!");
            }
            else{
                System.out.println("You fail to get away! \n You see him again, and he reaches for a ... \n \033Quick, do something! You can sidestep, backpedal, or reach for the armor on the table.\033");
                combat(player,enemy);
            }
        }
    }
}
