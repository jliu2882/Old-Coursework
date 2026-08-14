package com.company;

public class StudentRecord {
    private int[] scores;

    public StudentRecord(int[] scores){
        this.scores = scores;
    }

    public double average(int first, int last) {
        double sum = 0.0;
        for (int i = first; i <= last; i++) {
            sum += scores[i];
        }
        return sum / (last - first + 1);
    }


    public boolean hasImproved() {
        for (int k = 0; k < scores.length - 1; k++) {
            if (scores[k] > scores[k + 1]) {
                return false;
            }
        }
        return true;
    }

    public double finalAverage() {
        if (hasImproved()) {
            return average(scores.length / 2, scores.length - 1);
        } else {
            return average(0, scores.length - 1);
        }
    }
}