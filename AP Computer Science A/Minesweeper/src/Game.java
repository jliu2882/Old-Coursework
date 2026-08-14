<<<<<<< HEAD
import javafx.animation.AnimationTimer;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.Pane;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.stream.IntStream;

public class Game {
    private Board board;
    private Pane[][] cells;

    private Snake head;
    private ArrayList<Snake> entities;

    private Direction nextDirection = Directions.RIGHT;

    private int length = 1;
    public static String username;
    private boolean forceTick;

    public Game(Pane[][] cells) {
        // Construct Board
        Tile[][] fBoard = new Tile[Constants.BOARD_X][Constants.BOARD_Y];
        IntStream.range(0, Constants.BOARD_X).forEach(r -> {
            IntStream.range(0, Constants.BOARD_Y).forEach(c -> {
                fBoard[r][c] = new Tile(r, c);
            });
        });

        this.board = new Board(fBoard);
        this.cells = cells;

        // Generate default Entities
        Food food = new Food(Constants.FOOD_INITIAL_X, Constants.FOOD_INITIAL_Y);
        this.board.tileAt(Constants.FOOD_INITIAL_X, Constants.FOOD_INITIAL_Y).setEntity(food);

        Snake snake = new Snake(Constants.SNAKE_INITIAL_X, Constants.SNAKE_INITIAL_Y);
        this.board.tileAt(Constants.SNAKE_INITIAL_X, Constants.SNAKE_INITIAL_Y).setEntity(snake);

        this.head = snake; // This is just for convenience's sake, it should just be the first Snake in entities anyway
        this.entities = new ArrayList<>(Arrays.asList(snake));
    }

    /**
     * Generates a random position (including conflicts)
     *
     * @return the randomly generated Position
     */
    private static Position generateRandomPosition() {
        int x = (int) (Math.random() * Constants.BOARD_X);
        int y = (int) (Math.random() * Constants.BOARD_Y);

        return new Position(x, y);
    }

    public Board getBoard() {
        return board;
    }

    /**
     * Randomly generates a position (excluding conflicts)
     *
     * @return the generated Position
     */
    public Position generatePosition() {
        Position pos = Game.generateRandomPosition();

        while (this.board.tileAt(pos).isOccupied()) {
            pos = Game.generateRandomPosition();
        }
        return pos;
    }

    /**
     * Updates the "backend" part of the board
     */
    public void update() {
        // Propagate directions down the body, starts at -1 since tail is the end
        IntStream.rangeClosed(1, this.entities.size()).forEach(i -> {
            Snake snake = this.entities.get(this.entities.size() - i);

            if (snake.getNextPart() != null) {
                snake.getNextPart().setDirection(snake.getDirection());
            }
        });

        // Now we bring the new direction into the head
        this.head.setDirection(this.nextDirection);

        IntStream.range(0, this.entities.size()).forEach(i -> {
            Snake snake = this.entities.get(i);
            Position lastPosition = snake.getPosition();
            Position newPosition = lastPosition.shift(snake.getDirection());

            if (this.board.tileAt(newPosition).getEntity() instanceof Snake){
                Main.endgame(Main.stage);
            }

            if (this.board.tileAt(newPosition).getEntity() instanceof Food) {
                // Take advantage of how this.entities is setup
                Snake lastEgg = this.entities.get(this.entities.size() - 1);
                Position futurePosition = lastEgg.getPosition();
                Snake egg = new Snake(futurePosition);

                lastEgg.setNextPart(egg);
                egg.setDirection(lastEgg.getDirection());
                this.board.tileAt(lastPosition).setEntity(egg);
                this.entities.add(egg);

                // Generate new food
                Food food = new Food(this.generatePosition());
                this.board.tileAt(food.getPosition()).setEntity(food);
                length++;
            }

            this.board.tileAt(lastPosition).setEntity(null);
            this.board.tileAt(newPosition).setEntity(snake);
            snake.setPosition(newPosition);
        });
    }

    /**
     * Refreshes the graphical components, basically updating color
     */
    public void refresh() {
        IntStream.range(0, this.cells.length).forEach(r -> {
            Pane[] row = this.cells[r];
            IntStream.range(0, row.length).forEach(c -> {
                Pane cell = row[c];
                Tile cellTile = this.board.tileAt(r, c);

                cell.getStyleClass().removeAll("has-food", "has-snake");
                if (cellTile.isOccupied()) {
                    cell.getStyleClass().add(cellTile.getEntity() instanceof Food ? "has-food" : "has-snake");
                }
            });
        });
    }

    /**
     * And thus the game begins...
     */
    public void run() {
        // Preserve current scope before entering new one
        Game _this = this;

        new AnimationTimer() {
            private long tick;

            @Override
            public void handle(long now) {
                if (this.tick == 0) this.tick = now;
                final long dt = now - tick;

                if (_this.board.gameConditionLost) {
                    this.stop();
                    Main.endgame(Main.stage);
                }

                if (_this.forceTick || dt > 1 / Constants.FRAMES_PER_SECOND * Constants.NANO_CONVERSION_RATIO) {
                    _this.update();
                    _this.refresh();

                    this.tick = now;
                    _this.forceTick = false;
                }
            }
        }.start();
    }

    /**
     * Register a key press and change directions if it's an arrow key
     *
     * @param keyCode - the key that was pressed down
     */
    public void onKeyPressed(KeyCode keyCode) {
        Direction newDirection;

        if (keyCode == KeyCode.UP) newDirection = Directions.UP;
        else if (keyCode == KeyCode.DOWN) newDirection = Directions.DOWN;
        else if (keyCode == KeyCode.LEFT) newDirection = Directions.LEFT;
        else if (keyCode == KeyCode.RIGHT) newDirection = Directions.RIGHT;
        else newDirection = this.head.getDirection();

        if (!newDirection.equals(Direction.inverseOf(this.head.getDirection()))) {
            this.nextDirection = newDirection;
            this.forceTick = true;
        }
    }

    /**
     * The length registered in the game
     *
     * @return the one and only length the player has
     */
    public int getLength() {
        return length;
    }
    /**
     * The username registered in the game
     *
     * @return the one and only username the player has
     */
    public String getUsername() {
        return username;
    }
}
=======
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
>>>>>>> t/main
