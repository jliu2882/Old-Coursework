package jliu2882;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class DailySchedule {
    private ArrayList<Appointment> apptList;

    public DailySchedule(){
        apptList = new ArrayList();
    }
    public void clearConflicts(Appointment appt){
        for(int i = apptList.size() -1; i >= 0 ;i--){
            if(appt.conflictsWith(apptList.get(i))){
                apptList.remove(i);
            }
        }
    }

    public boolean addAppt(Appointment appt, boolean emergency){
        if(emergency){
            clearConflicts(appt);
        }
        for(int i = apptList.size() -1; i >=0;i--){
            if(apptList.get(i).conflictsWith(appt)){
                return false;
            }
        }
        apptList.add(appt);
        return true;
    }
}
