import java.util.*;

public class Team18SortCompetition extends SortCompetition{
    public int challengeOne(int[] arr){
        radixSort(arr);
        return median(arr);
    }

    public int challengeTwo(String[] arr, String query){
        radixSort(arr,'a','z');
        return sequentialSearch(arr,query);
    }

    public int challengeThree(int[] arr){
        insertionSort(arr);
        return median(arr);
    }

    public int challengeFour(int[][] arr){
        double[] medianArr = new double[arr.length];
        for(int i = 0; i < arr.length; i ++){
            radixSort(arr[i]);
            medianArr[i] = median(arr[i]);
        }
        insertionSort(medianArr,arr);
        return median(medianArr);
    }

    public int challengeFive(Comparable[] arr, Comparable query){
        mergeSort(arr);
        return sequentialSearch(arr,query);
    }
    public String greeting(){
        return "beep boop";
    }





    public static String[] alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
    public static void swap(int list1[], int i, int j) {
        int temp = list1[i];
        list1[i] = list1[j];
        list1[j] = temp;
    }
    public static void swap(double list1[], int i, int j) {
        double temp = list1[i];
        list1[i] = list1[j];
        list1[j] = temp;
    }
    public static void swap(int list1[][], int i, int j) {
        int[] temp = list1[i];
        list1[i] = list1[j];
        list1[j] = temp;
    }
    public static void swap(String list1[], int i, int j) {
        String temp = list1[i];
        list1[i] = list1[j];
        list1[j] = temp;
    }
    public static void swap(Comparable list1[], int i, int j) {
        Comparable temp = list1[i];
        list1[i] = list1[j];
        list1[j] = temp;
    }
    public static String randStr() {
        int wordLength = randInt(5) + 3;
        String result = "";
        for (int i = 0; i < wordLength; i++) {
            result += alphabet[randInt(25)];
        }
        return result;
    }
    public static int randInt(int max) {
        return (int) (Math.random() * (max + 1));
    }
    public static double randDoub(int max) {
        return Math.random() * (max + 1);
    }
    public static int[] randIntArr(int count, int max) {
        int[] list1 = new int[count];
        for (int i = 0; i < list1.length; i++) {
            list1[i] = randInt(max);
        }
        return list1;
    }
    public static double[] randDoubArr(int count, int max) {
        double[] list1;
        list1 = new double[count];
        for (int i = 0; i < list1.length; i++) {
            list1[i] = randDoub(max);
        }
        return list1;
    }
    public static String[] randStrArr(int count) {
        String[] list1;
        list1 = new String[count];
        for (int i = 0; i < list1.length; i++) {
            list1[i] = randStr();
        }
        return list1;
    }

    public static void bubbleSort(String[] list1) {
        for (int i = 0; i < list1.length; i++) {
            for (int j = 0; j < list1.length - 1; j++) {
                if (list1[j + 1].compareTo(list1[j]) < 0) {
                    swap(list1, j, j + 1);
                }
            }
        }
    }
    public static void selectionSort(double[] list1) {
        for (int i = 0; i < list1.length; i++) {
            for (int j = i + 1; j < list1.length; j++) {
                if (list1[i] > list1[j]) {
                    swap(list1, i, j);
                }
            }
        }
    }
    public static void insertionSort(int[] list1) {
        for (int i = 1; i < list1.length; i++) {
            int temp = list1[i];
            int j;
            for (j = i - 1; j >= 0 && temp < list1[j]; j--) {
                list1[j + 1] = list1[j];
            }
            list1[j + 1] = temp;
        }
    }
    public static void insertionSort(double[] list1, int[][] arr) {
        for (int i = 1; i < list1.length; i++) {
            double temp = list1[i];
            int j;
            for (j = i - 1; j >= 0 && temp < list1[j]; j--) {
                swap(arr,j+1,j);
                list1[j + 1] = list1[j];
            }
            list1[j + 1] = temp;
        }
    }
    public static void mergeSort(int[] arr) {
        int[] temp = new int[arr.length];
        mergeSortHelper(arr, 0, arr.length - 1, temp);
    }
    public static void mergeSortHelper(int[] arr, int left, int right, int[] temp) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSortHelper(arr, left, mid, temp);
            mergeSortHelper(arr, mid + 1, right, temp);
            merge(arr, left, mid, right, temp);
        }
    }
    public static void merge(int[] arr, int left, int mid, int right, int[] temp) {
        int i = left;
        int j = mid + 1;
        int k = left;
        while (i <= mid && j <= right) {
            if (arr[i] < arr[j]) {
                temp[k] = arr[i];
                i++;
            } else {
                temp[k] = arr[j];
                j++;
            }
            k++;
        }
        while (i <= mid) {
            temp[k] = arr[i];
            i++;
            k++;
        }
        while (j <= right) {
            temp[k] = arr[j];
            j++;
            k++;
        }
        for (k = left; k <= right; k++) {
            arr[k] = temp[k];
        }
    }
    public static void mergeSort(Comparable[] arr) {
        Comparable[] temp = new Thingy[arr.length];
        mergeSortHelper(arr, 0, arr.length - 1, temp);
    }
    public static void mergeSortHelper(Comparable[] arr, int left, int right, Comparable[] temp) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSortHelper(arr, left, mid, temp);
            mergeSortHelper(arr, mid + 1, right, temp);
            merge(arr, left, mid, right, temp);
        }
    }
    public static void merge(Comparable[] arr, int left, int mid, int right, Comparable[] temp) {
        int i = left;
        int j = mid + 1;
        int k = left;
        while (i <= mid && j <= right) {
            if (arr[i].compareTo(arr[j])<=0) {
                temp[k] = arr[i];
                i++;
            } else {
                temp[k] = arr[j];
                j++;
            }
            k++;
        }
        while (i <= mid) {
            temp[k] = arr[i];
            i++;
            k++;
        }
        while (j <= right) {
            temp[k] = arr[j];
            j++;
            k++;
        }
        for (k = left; k <= right; k++) {
            arr[k] = temp[k];
        }
    }
    public static void quickSort(Thingy[] arr, int left, int right) {
        if (left < right) {
            int pivot = partition(arr, left, right);
            quickSort(arr, left, pivot - 1);
            quickSort(arr, pivot + 1, right);
        }
    }
    public static int partition(Thingy[] arr, int left, int right) {
        Thingy pivot = arr[right];
        int i = left - 1;
        for (int j = left; j < right; j++) {
            if (arr[j].compareTo(pivot)<=0) {
                i++;
                swap(arr, i, j);
            }
        }
        swap(arr, i + 1, right);
        return i + 1;
    }
    public static void radixSort(int[] arr){
        int m = getMax(arr);
        for(int exp = 1; m/exp>0;exp*=10){
            countSort(arr,exp);
        }
    }
    public static int getMax(int[] arr){
        int max = arr[0];
        for(int i = 1; i < arr.length; i++){
            if(arr[i]>max){
                max = arr[i];
            }
        }
        return max;
    }
    public static void radixSort(String[] arr,char lower, char upper){
        int maxIndex = 0;
        for(int i = 0; i <arr.length; i++){
            if(arr[i].length()-1 > maxIndex){
                maxIndex = arr[i].length()-1;
            }
        }
        for(int i = maxIndex;i>=0;i--){
            countSort(arr,i,lower,upper);
        }
    }
    public static void countSort(int[] arr, int exp){
        int output[] = new int[arr.length];
        int i;
        int count[] = new int[10];
        Arrays.fill(count,0);
        for(i = 0; i < arr.length; i++){
            count[(arr[i]/exp)%10]++;
        }
        for(i=1;i<10;i++){
            count[i] += count[i-1];
        }
        for(i=arr.length-1;i>=0;i--){
            output[count[(arr[i]/exp)%10]-1]=arr[i];
            count[(arr[i]/exp)%10]--;
        }
        for(i=0; i<arr.length;i++){
            arr[i]=output[i];
        }
    }
    public static void countSort(String[] arr,int index, char lower, char upper){
        int[] countArray = new int[(upper-lower)+2];
        String[] tempArray = new String[arr.length];
        Arrays.fill(countArray,0);
        for(int i = 0; i < arr.length;i++){
            int charIndex = (arr[i].length()-1 < index) ? 0 : ((arr[i].charAt(index) - lower)+1);
            countArray[charIndex]++;
        }
        for(int i = 1; i < countArray.length;i++){
            countArray[i] += countArray[i-1];
        }
        for(int i = arr.length-1;i>=0;i--){
            int charIndex = (arr[i].length()-1 < index) ? 0 : (arr[i].charAt(index) - lower)+1;
            tempArray[countArray[charIndex]-1] = arr[i];
            countArray[charIndex]--;
        }for(int i=0;i<tempArray.length;i++){
            arr[i] = tempArray[i];
        }
    }
    public static int sequentialSearch(int[] elements, int target){
        for(int j = 0; j < elements.length; j++){
            if(elements[j]==target){
                return j;
            }
        }
        return -1;
    }
    public static int sequentialSearch(String[] elements, String target){
        for(int j = 0; j < elements.length; j++){
            if(elements[j].equals(target)){
                return j;
            }
        }
        return -1;
    }
    public static int sequentialSearch(Comparable[] elements, Comparable target){
        for(int j = 0; j < elements.length; j++){
            if(elements[j].compareTo(target)==0){
                return j;
            }
        }
        return -1;
    }
    public static int binarySearch(int[] elements, int target){
        //given elements is sorted
        int left = 0;
        int right = elements.length-1;
        while ( left <= right){
            int middle = (left+right)/2;
            if(target < elements[middle]){
                right = middle - 1;
            }
            else if( target > elements[middle]){
                left = middle + 1;
            }
            else{
                return middle;
            }
        }
        return -1;
    }

    public static int median(int[] arr){
        return (arr[arr.length/2-1+(arr.length%2)]+arr[arr.length/2])/2;
    }
    public static int median(double[] arr){
        return (int)((arr[arr.length/2-1+(arr.length%2)]+arr[arr.length/2])/2);
    }
}
