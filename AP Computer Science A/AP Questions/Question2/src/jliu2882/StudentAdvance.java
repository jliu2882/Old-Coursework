package jliu2882;

public class StudentAdvance extends Advance {
    private double price = 0;

    public StudentAdvance(int days) {
        super(days);
        this.price = super.getPrice() / 2;
    }

    @Override
    public double getPrice() {
        return this.price;
    }

    @Override
    public String toString() {
        return super.toString() + "\n(student ID required)";
    }
}
