import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

public class HeapFX extends Application {
	private Label heap = new Label("");

	private Button add = new Button("Add an element to the heap");
	private TextField addText = new TextField();
	private Button minus = new Button("Remove an element from the heap");
	private Label tryingmybest = new Label("Spacing the heap was hard :(");
	private static HeapVisualized hv = new HeapVisualized();
	public void start(Stage primaryStage) {
		BorderPane root = new BorderPane();
		GridPane pane = new GridPane();
		pane.setHgap(5);
		pane.setVgap(5);
		pane.add(add, 0, 0);
		pane.add(minus, 0, 1);
		pane.add(addText, 1, 0);
		pane.add(tryingmybest, 1, 1);
		pane.add(heap,0,2);
		add.setOnAction(e -> {
			if(addText.getText().length()>0) {
				try {
					hv.add(Integer.parseInt(addText.getText()));
				}catch(NumberFormatException e1){
					System.out.println("Invalid Input(Maybe your number is too large :()");
				}
			}
			else {
				System.out.println("Enter an element to add first!");
			}
			updateHeap(heap);
			//heap.setDisable(false);
			//heap.setVisible(true);
		});
		minus.setOnAction(e -> {
			if(hv.remove()==null)
				System.out.println("Enter an element first!");
			updateHeap(heap);
			//heap.setDisable(true);
			//heap.setVisible(false);
		});
		root.setCenter(pane);
		
		Scene scene = new Scene(root, 1000, 1000);
		primaryStage.setTitle("Visualizing a Heap");
		primaryStage.setScene(scene);
		
		primaryStage.show();
	}
	public static void updateHeap(Label heap) {
		heap.setText("");
		int height = (int)Math.ceil(Math.log(hv.getSize() +  1) / Math.log(2));
		for(int i = 1; i<= height;i++) {
			heap.setText(heap.getText()+hv.getRow(i,height)+"\n");
		}
	}
	public static void main(String[] args) {
		launch(args);
	}
}
