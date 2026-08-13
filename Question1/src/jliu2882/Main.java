package jliu2882;

public class Main {

    public static void main(String[] args) {
        TimeInterval t1 = new TimeInterval(100,200);
        TimeInterval t2 = new TimeInterval(200,300);
        TimeInterval t3 = new TimeInterval(300,400);
        TimeInterval t4 = new TimeInterval(400,500);
        TimeInterval t5 = new TimeInterval(500,600);

        Appointment a1 = new Appointment(t1);
        Appointment a2 = new Appointment(t2);
        Appointment a3 = new Appointment(t3);
        Appointment a4 = new Appointment(t4);
        Appointment a5 = new Appointment(t5);
        Appointment a6 = new Appointment(t1);
        Appointment a7 = new Appointment(t2);
        Appointment a8 = new Appointment(t3);
        Appointment a9 = new Appointment(t4);
        Appointment a10 = new Appointment(t5);

        DailySchedule ds1 = new DailySchedule();

        ds1.addAppt(a1,false);
        ds1.addAppt(a2,false);
        ds1.addAppt(a3,false);
        ds1.addAppt(a4,false);
        ds1.addAppt(a5,false);
        ds1.addAppt(a6,false);
        ds1.addAppt(a7,false);
        ds1.addAppt(a8,false);
        ds1.addAppt(a9,false);
        ds1.addAppt(a10,false);

        System.out.println(ds1);
    }
}
