package People;

public abstract class Criminal extends Person{
    public Criminal (String firstName, String familyName, int xLoc, int yLoc,int hp){
        super(firstName,familyName,xLoc,yLoc,"Criminal",hp);
    }
    public abstract void moveEnemy(Person p);
}
