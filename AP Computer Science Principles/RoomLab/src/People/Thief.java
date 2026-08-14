package People;

public class Thief extends Criminal {
    public Thief (String firstName, String familyName, int xLoc, int yLoc, int hp){
        super(firstName,familyName,xLoc,yLoc,1);
    }
    public void moveEnemy(Person p){
        for(int i = 0; i <2; i++) {
            int xDif = Math.abs(p.getxLoc() - this.getxLoc());
            int yDif = Math.abs(p.getyLoc() - this.getyLoc());
            if (xDif == yDif && (xDif + yDif != 0)) {
                if (((int) Math.random() * 2) == 1) {
                    yDif++;
                } else {
                    xDif++;
                }
            }
            if (xDif == 0 && yDif == 0) {
                this.setxLoc(getxLoc());
                this.setyLoc(getyLoc());
            } else if (xDif > yDif) {
                if (p.getxLoc() == this.getxLoc()) {
                    this.setyLoc(this.getxLoc());
                } else if (p.getxLoc() > this.getxLoc()) {
                    this.setxLoc(this.getxLoc() + 1);
                } else {
                    this.setxLoc(this.getxLoc() - 1);
                }
            } else {
                if (p.getyLoc() > this.getyLoc()) {
                    this.setyLoc(this.getyLoc() + 1);
                } else {
                    this.setyLoc(this.getyLoc() - 1);
                }
            }
        }
    }
}
