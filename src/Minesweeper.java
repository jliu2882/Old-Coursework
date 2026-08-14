import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class Minesweeper extends Application {
	private Label height = new Label("Height ");
	private Label width = new Label("Width ");
	private Label bombs = new Label("Bombs ");
	private Label heightBeginner = new Label("9");
	private Label widthBeginner = new Label("9");
	private Label bombsBeginner = new Label("10");
	private Label heightIntermediate = new Label("16");
	private Label widthIntermediate = new Label("16");
	private Label bombsIntermediate = new Label("40");
	private Label heightExpert = new Label("16");
	private Label widthExpert = new Label("30");
	private Label bombsExpert = new Label("99");
	private Label customText = new Label("For custom: fill in fields then press \"Custom\" button");
	
	private Button beginner = new Button("Beginner");
	private Button intermediate = new Button("Intermediate");
	private Button expert = new Button("Expert");
	private Button custom = new Button("Custom");

	private TextField customHeight = new TextField();
	private TextField customWidth = new TextField();
	private TextField customBomb = new TextField();
	public void start(Stage primaryStage) {
		BorderPane root = new BorderPane();
		GridPane pane = new GridPane();
		pane.setHgap(5);
		pane.setVgap(5);
		pane.add(height,1,0);
		pane.add(width,2,0);
		pane.add(bombs,3,0);
		pane.add(heightBeginner,1,1);
		pane.add(widthBeginner,2,1);
		pane.add(bombsBeginner,3,1);
		pane.add(heightIntermediate,1,2);
		pane.add(widthIntermediate,2,2);
		pane.add(bombsIntermediate,3,2);
		pane.add(heightExpert,1,3);
		pane.add(widthExpert,2,3);
		pane.add(bombsExpert,3,3);
		pane.add(customHeight,1,4);
		pane.add(customWidth,2,4);
		pane.add(customBomb,3,4);
		pane.add(beginner, 0, 1);
		beginner.setOnAction(e -> {
			Game game = new Game(9,9,10);
			game.start();
		});
		pane.add(intermediate, 0, 2);
		intermediate.setOnAction(e -> {
			Game game = new Game(16,16,40);
			game.start();
		});
		pane.add(expert, 0, 3);
		expert.setOnAction(e -> {
			Game game = new Game(16,30,99);
			game.start();
		});
		pane.add(custom, 0, 4);
		custom.setOnAction(e -> {
			Game game = new Game(Integer.parseInt(customHeight.getText()),Integer.parseInt(customWidth.getText()),Integer.parseInt(customBomb.getText()));
			game.start();
		});
		
		customHeight.setPrefWidth(50);
		customWidth.setPrefWidth(50);
		customBomb.setPrefWidth(50);
		root.setCenter(pane);
		root.setBottom(customText);
		
		Scene scene = new Scene(root, 275, 175);
		primaryStage.setTitle("Game Settings");
		primaryStage.setScene(scene);
		
		primaryStage.show();
	}
	public static void main(String[] args) {
		launch(args);
	}
}