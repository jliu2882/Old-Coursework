package jliu2882;

public class Appointment {
    public TimeInterval interval;

    public Appointment(TimeInterval interval){
        this.interval = interval;
    }

    public TimeInterval getTime(){
        return interval;
    }
    public boolean conflictsWith(Appointment other){
        if(this.interval.overlapsWith(other.getTime())){
            return true;
        }
        return false;
    }
}
