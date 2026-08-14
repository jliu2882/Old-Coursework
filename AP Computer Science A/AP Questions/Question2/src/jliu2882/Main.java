package jliu2882;

public class Main {

    public static void main(String[] args) {
        Walkup walkup = new Walkup();
        Advance ad0 = new Advance(3);
        Advance ad1 = new Advance(15);
        StudentAdvance sad0 = new StudentAdvance(3);
        StudentAdvance sad1 = new StudentAdvance(15);

        System.out.println(walkup);
        System.out.println(ad0);
        System.out.println(ad1);
        System.out.println(sad0);
        System.out.println(sad1);
    }
}
