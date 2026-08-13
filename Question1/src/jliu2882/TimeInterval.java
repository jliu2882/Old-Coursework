package jliu2882;

public class TimeInterval {
    public int start;
    public int end;

    public TimeInterval(int startTime, int endTime) {
        this.start = startTime;
        this.end = endTime;
    }

    public boolean overlapsWith (TimeInterval interval){
        if(this.start>=interval.start && this.start<=interval.end ||
                this.end>=interval.start && this.end<=interval.end){
            return true;
        }
        return false;
    }
}
