public class Runner {
    public static void main(String[] args){
        System.out.println("Medians are rounded to the nearest integer");

        SortCompetition team18 = new Team18SortCompetition();
        int[] randIntArr = randIntArr(10000,10000);
        String [] randStringArr = randStrArr(10000,5);
        int[] mostlySorted = mostlySortedIntArr(100000,10000);
        int[][] randMultiIntArr =  randMultiIntArr(1000,1000,10000);
        Thingy[] randomThingArr = randomThingArr(10000);
        Thingy thing = new Thingy(0,3);

        System.out.println("Unsorted");
        printArr(randIntArr);

        long time = System.currentTimeMillis();
        double median = team18.challengeOne(randIntArr);
        time = System.currentTimeMillis() - time;
        System.out.println("Challenge One Time Taken: " + (time * 0.001) + " Seconds");
        System.out.println("Median equals: " + median);

        System.out.println("Sorted");
        printArr(randIntArr);



        System.out.println("\nUnsorted");
        printArr(randStringArr);

        time = System.currentTimeMillis();
        double index = team18.challengeTwo(randStringArr, "tests");
        time = System.currentTimeMillis() - time;
        System.out.println("Challenge Two Time Taken: " + (time * 0.001) + " Seconds");
        System.out.println("Query appears at: " + index);

        System.out.println("Sorted");
        printArr(randStringArr);



        System.out.println("\nUnsorted");
        //printArr(mostlySorted);

        time = System.currentTimeMillis();
        median = team18.challengeThree(mostlySorted);
        time = System.currentTimeMillis() - time;
        System.out.println("Challenge Three Time Taken: " + (time * 0.001) + " Seconds");
        System.out.println("Median equals: " + median);

        System.out.println("Sorted, just trust me");
        //printArr(mostlySorted);



        System.out.println("\nUnsorted");
        //printArr(randMultiIntArr);

        time = System.currentTimeMillis();
        median = team18.challengeFour(randMultiIntArr);
        time = System.currentTimeMillis() - time;
        System.out.println("Challenge Four Time Taken: " + (time * 0.001) + " Seconds");
        System.out.println("Median of the median arrays equals: " + median);

        System.out.println("Sorted, just trust me");
        //printArr(randMultiIntArr);



        System.out.println("\nUnsorted");
        printArr(randomThingArr);

        time = System.currentTimeMillis();
        index = team18.challengeFive(randomThingArr, thing);
        time = System.currentTimeMillis() - time;
        System.out.println("Challenge Five Time Taken: " + (time * 0.001) + " Seconds");
        System.out.println("Thingy appears at: " + index);

        System.out.println("Sorted");
        printArr(randomThingArr);
    }





    public static void printArr(int[] arr){
        for(int num : arr){
            System.out.print(num + " ");
        }
        System.out.print("\n");
    }
    public static void printArr(double[] arr){
        for(double num : arr){
            System.out.print(num + " ");
        }
        System.out.print("\n");
    }
    public static void printArr(String[] arr){
        for(String num : arr){
            System.out.print(num + " ");
        }
        System.out.print("\n");
    }
    public static void printArr(int[][] arr){
        for(int[] num : arr){
            printArr(num);
            System.out.println("\n");
        }
    }
    public static void printArr(Thingy[] arr){
        for(Comparable num : arr){
            System.out.print(num + " ");
        }
        System.out.print("\n");
    }

    public static String[] alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};

    public static int randInt(int max) {
        return (int) (Math.random() * (max + 1));
    }
    public static String randStr(int max) {
        String result = "";
        for (int i = 0; i < max; i++) {
            result += alphabet[randInt(25)];
        }
        return result;
    }

    public static int[] randIntArr(int count, int max) {
        int[] list1 = new int[count];
        for (int i = 0; i < list1.length; i++) {
            list1[i] = randInt(max);
        }
        return list1;
    }
    public static int[] mostlySortedIntArr(int count, int max){
        int[] list1 = new int[count];
        for (int i = 0; i < list1.length; i++) {
            list1[i] = randInt(max);
        }
        Team18SortCompetition.radixSort(list1);
        for(int i = 0; i < list1.length;i++){
            if(Math.random()>=0.75){
                list1[i] = randInt(max);
            }
        }
        return list1;
    }
    public static String[] randStrArr(int count, int max) {
        String[] list1;
        list1 = new String[count];
        for (int i = 0; i < list1.length; i++) {
            list1[i] = randStr(max);
        }
        return list1;
    }
    public static Thingy[] randomThingArr(int num){
        Thingy[] things = new Thingy[num];
        for(int i = 0; i < num; i ++){
            things[i] = new Thingy(i+1);
        }
        return things;
    }

    public static int[][] randMultiIntArr(int rows, int cols, int max){
        int[][] arr = new int[rows][cols];
        for(int i = 0; i < arr.length; i ++){
            arr[i] = randIntArr(cols,max);
        }
        return arr;
    }
}
