package com.company;

public class Runner {

    public static void main(String[] args) {
        //Eugene Korsunsky and Jack Liu
        int[] score1 = {50,50,20,80,53};
        int[] score2 = {20,50,50,53,80};
        int[] score3 = {20,50,50,80};

        StudentRecord sr1 = new StudentRecord(score1);
        StudentRecord sr2 = new StudentRecord(score2);
        StudentRecord sr3 = new StudentRecord(score3);

        System.out.println(sr1.hasImproved());
        System.out.println(sr2.hasImproved());
        System.out.println(sr3.hasImproved());

        System.out.println(sr1.finalAverage());
        System.out.println(sr2.finalAverage());
        System.out.println(sr3.finalAverage());
    }
}
