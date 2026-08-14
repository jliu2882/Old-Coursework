public class Thingy implements Comparable<Thingy>{
    private int totalTime;
    private int num;

    public Thingy(int num){
        this.totalTime = (int)(Math.random()*10000);
        this.num = num;
    }
    public Thingy(int num, int value){
        this.totalTime = value;
        this.num = num;
    }

    @Override
    public int compareTo(Thingy other){
        return this.totalTime - other.totalTime;
    }

    public String toString(){
        return "Thingy #" + this.num + " : " + this.totalTime + " //";
    }
}