package jliu2882;

public class SubstringChecker implements Checker{
    private String checker;

    public SubstringChecker(String checker){
        this.checker = checker;
    }
    public boolean accept(String text){
        for(int i = 0; i <= text.length()-checker.length();i++){
            if(text.substring(i,i+checker.length()).equals(checker)){
                return true;
            }
        }
        return false;
    }

    public String getChecker(){
        return checker;
    }
}
