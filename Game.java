import java.util.Random;

import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

public class Game{
	private int height;
	private int width;
	private int bombs;
	private int empty;
	private Tile[][] tileArr;
	public Game(int height, int width, int bombs) {
		this.height = height;
		this.width = width;
		this.bombs = bombs;
		this.empty = height*width-bombs;
		if(empty<0) {
			Stage stage = new Stage();
			GridPane pane = new GridPane();
			Label label = new Label("Bombs set to " + height*width + " by default.");
			pane.add(label, 0, 0);
			stage.setTitle("Too many bombs");
			stage.setScene(new Scene(pane,500,500));
			stage.show();
			this.empty = 0;
			this.bombs = height*width;
		}
		this.tileArr = new Tile[width][height];
	}
	public void start() {
		BorderPane pane = new BorderPane();
		GridPane pane2 = new GridPane();
		for(int i = 0; i < width; i++) {
			for(int j = 0; j < height; j++) {
				Tile tile = new Tile(i,j);
				tile.setOnAction(e -> {
					reveal(tile);
				});
				pane2.add(tile,i,j);
				tileArr[i][j] = tile;
			}
		}
		mines(tileArr);
		pane.setCenter(pane2);
		Button settings = new Button("Close Game");
		settings.setPrefWidth(width*20);
		settings.setAlignment(Pos.TOP_LEFT);
		pane.setTop(settings);
		pane.setBottom(new Label("You may have to expand window size to see all the mines"));
		Stage stage2 = new Stage();
		settings.setOnAction(e -> {
			stage2.hide();
		});
		stage2.setTitle("Minesweeper");
		stage2.setScene(new Scene(pane,width*20,50+height*25));
		stage2.show();		
	}
	public void mines(Tile[][] buttons) {
		Random rand = new Random();
	    int mineCount = 0;
	    while (mineCount < bombs)
	    {       
	    	int randomInteger = (int) (rand.nextDouble() * buttons.length);
	    	int randomInteger2 = (int) (rand.nextDouble() * buttons[0].length);
	        if (buttons[randomInteger][randomInteger2].isBomb())
	            continue;
	        else
	        {
	            buttons[randomInteger][randomInteger2].setBomb(true);
	            mineCount++;
	        }
	    }
	}
	private void reveal(Tile tile) {
        tile.setHidden(false);
        tile.setDisable(true);
        empty--;
        if (tile.isBomb()) {
        	for(int i = 0; i < width; i++) {
        		for(int j = 0; j < height; j++) {
        			if(tileArr[i][j].isBomb()) {
        				tileArr[i][j].setText("X");
        			}
        		}
        	}
			Stage stageMain = (Stage) tile.getScene().getWindow();
			stageMain.close();
        	GridPane pane = new GridPane();
        	pane.add(new Label("You lose"), 0, 0);
        	Scene scene = new Scene(pane,100,100);
        	Stage stage = new Stage();
        	stage.setScene(scene);
        	stage.show();
        }else if(empty<=0) {
			Stage stageMain = (Stage) tile.getScene().getWindow();
			stageMain.close();
        	GridPane pane = new GridPane();
        	pane.add(new Label("You win"), 0, 0);
        	Scene scene = new Scene(pane,100,100);
        	Stage stage = new Stage();
        	stage.setScene(scene);
        	stage.show();
        }
        int nearBomb = 0;
    	for(int i = 0; i < width; i++) {
    		for(int j = 0; j < height; j++) {
    			if(tile.adjacent(tileArr[i][j])&&tileArr[i][j].isBomb()) {
    				nearBomb++;
    			}
    		}
    	}
    	if(nearBomb==0) {
    		for(int i = 0; i < width; i++) {
        		for(int j = 0; j < height; j++) {
        			if(tile.adjacent(tileArr[i][j])&&tileArr[i][j].isHidden()) {
        				reveal(tileArr[i][j]);
        			}
        		}
        	}
    	}
    	else {
    		tile.setText(""+nearBomb);
    	}
    }	
}
