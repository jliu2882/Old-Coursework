
public class HeapVisualized <E extends Comparable>{

	private java.util.ArrayList<E> list = new java.util.ArrayList<E>();
	public HeapVisualized() {
	}
	public HeapVisualized(E[] objects) {
		for (int i = 0; i < objects.length; i++)
			add(objects[i]);
	}
	
	/** Add a new object into the heap */
	public void add(E newObject) {
		list.add(newObject); // Append to the heap
		int currentIndex = list.size() - 1; // The index of the last node
		while (currentIndex > 0) {
			int parentIndex = (currentIndex - 1) / 2;
			// Swap if the current object is greater than its parent
			if (list.get(currentIndex).compareTo(list.get(parentIndex)) > 0) {
				E temp = list.get(currentIndex);
				list.set(currentIndex, list.get(parentIndex));
				list.set(parentIndex, temp);
			} else break; // the tree is a heap now
			currentIndex = parentIndex;
		}

	}
	public E remove() {
		if (list.size() == 0) return null;
		E removedObject = list.get(0);
		list.set(0, list.get(list.size() - 1));
		list.remove(list.size() - 1);
		int currentIndex = 0;
		while (currentIndex < list.size()) {
			int leftChildIndex = 2 * currentIndex + 1;
			int rightChildIndex = 2 * currentIndex + 2;
			// Find the maximum between two children
			if (leftChildIndex >= list.size()) break; // The tree is a heap
			int maxIndex = leftChildIndex;
			if (rightChildIndex < list.size()) {
				if (list.get(maxIndex).compareTo(list.get(rightChildIndex)) < 0) {
					maxIndex = rightChildIndex;
				}
			}
			// Swap if the current node is less than the maximum
			if (list.get(currentIndex).compareTo(list.get(maxIndex)) < 0) {
				E temp = list.get(maxIndex);
				list.set(maxIndex, list.get(currentIndex));
				list.set(currentIndex, temp);
				currentIndex = maxIndex;
			}
			else
			break; // The tree is a heap
		}
		return removedObject;
	}
	/** Get the number of nodes in the tree */
	public int getSize() {
		return list.size();
	}	
	public java.util.ArrayList<E> getList(){
		return list;
	}
	public String getRow(int row,int height){
		String data = "";
		int num = 0;
		for(int i = 0; i< row; i++) {
			num+=Math.pow(2, i);
		}
		String space = spaceMultiply(4*((int)(Math.pow(2,height)/Math.pow(2, row+1)))+1);
		for(int i = (int) (num-Math.pow(2, row-1)); i < num; i++){
			if(getSize()>i) {
				data+=space+(i%2==1?spaceMultiply(height-row):"")+"("+list.get(i)+")";
			}
		}
		return data;
	}
	public static String spaceMultiply(int row) {
		String space = "";
		for(int i =0 ; i < row; i++) {
			space+=" ";
		}
		return space;
	}
	public static void printArr(HeapVisualized arr){
		for(Object item: arr.list) {
			System.out.println(item + " ");	
		}
		System.out.println();
	}
}
