package jliu2882;

public class Main {

    public static void main(String[] args) {
        Checker broccoliChecker = new SubstringChecker("broccoli");
        System.out.println(broccoliChecker.accept("broccoli"));
        System.out.println(broccoliChecker.accept("I like broccoli"));
        System.out.println(broccoliChecker.accept("carrots are great"));
        System.out.println(broccoliChecker.accept("Broccoli Bonanza"));

        System.out.println("");

        Checker bChecker = new SubstringChecker("beets");
        Checker cChecker = new SubstringChecker("carrots");
        Checker bothChecker = new AndChecker(bChecker,cChecker);
        Checker aChecker = new SubstringChecker("artichokes");
        Checker veggies = new AndChecker(bothChecker,aChecker);

        System.out.println(bothChecker.accept("I love beets and carrots"));
        System.out.println(bothChecker.accept("beets are great"));
        System.out.println(veggies.accept("artichokes, beets, and carrots"));

        System.out.println("");

        //aChecker defined
        Checker kChecker = new SubstringChecker("kale");
        Checker notA = new NotChecker(aChecker);
        Checker notK = new NotChecker(kChecker);
        Checker yummyChecker = new AndChecker(notA,notK);

        System.out.println(yummyChecker.accept("chocalate truffles"));
        System.out.println(yummyChecker.accept("kale is great"));
        System.out.println(yummyChecker.accept("Yuck: artichokes & kale"));
    }
}
