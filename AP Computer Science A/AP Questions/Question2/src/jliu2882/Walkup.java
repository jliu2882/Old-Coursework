package jliu2882;

public class Walkup extends Ticket {
    private double price = 0;

    public Walkup() {
        super();
        this.price = 50;
    }

    public double getPrice() {
        return this.price;
    }
}
