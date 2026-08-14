package jliu2882;

import java.util.ArrayList;

public class StepTracker {
    private int minSteps;
    private ArrayList<Integer> arrList;

    public StepTracker(int minSteps){
        this.minSteps = minSteps;
        this.arrList = new ArrayList<Integer>();
    }

    public int activeDays(){
        int count = 0;
        for(int i = 0; i < arrList.size();i++){
            if(arrList.get(i)>=minSteps){
                count++;
            }
        }
        return count;
    }

    public double averageSteps(){
        double sum = 0;
        for(int i = 0; i < arrList.size();i++){
            sum+= arrList.get(i);
        }
        if(arrList.size()==0){
            return 0;
        }
        return sum/arrList.size();
    }

    public void addDailySteps(int steps){
        arrList.add(steps);
    }
}
