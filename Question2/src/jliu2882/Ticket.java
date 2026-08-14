package jliu2882;

public abstract class Ticket {
    private int serialNumber;

    public Ticket() {
        this.serialNumber = getNextSerialNumber();
    }

    public abstract double getPrice();

    public String toString() {
        return "Number: " + this.serialNumber + "\nPrice: " + this.getPrice();
    }

    private static int getNextSerialNumber() {
        return (int) (Math.random() * 1000);
    }
}
