package jliu2882;

public interface Checker {
    /**
     * @param text a string to consider for acceptance
     * @return true if it accepts; false otherwise
     */
    boolean accept(String text);
    String getChecker();
}
