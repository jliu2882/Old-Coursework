package jliu2882;

public class Advance extends Ticket {
    private double price = 0;

    public Advance(int days) {
        super();
        this.price = days >= 10 ? 30 : 40;
    }

    public double getPrice() {
        return this.price;
    }
}
