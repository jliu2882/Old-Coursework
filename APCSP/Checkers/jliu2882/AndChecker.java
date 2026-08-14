package jliu2882;

public class AndChecker implements Checker{
    private Checker a;
    private Checker b;

    public AndChecker(Checker a, Checker b){
        this.a = a;
        this.b = b;
    }

    public boolean accept(String text){
        return (a.accept(text) && b.accept(text));
    }
    public String getChecker(){
        return a.getChecker() + " || " + b.getChecker();
    }
}
