<<<<<<< HEAD
public class Tile {
    private Position position;
    private Entity entity;

    /**
     * Creates a tile at `position`
     *
     * @param position - the position of the tile
     */
    public Tile(Position position) {
        this.position = position;
    }

    /**
     * Creates a tile at (x, y)
     *
     * @param x - the x coordinate
     * @param y - the y coordinate
     */
    public Tile(int x, int y) {
        this.position = new Position(x, y);
    }

    /**
     * Creates a tile at `position` occupied by `entity`
     *
     * @param position - the position of the tile
     * @param entity   - the entity occupying
     */
    public Tile(Position position, Entity entity) {
        this.position = position;
        this.entity = entity;
    }

    /**
     * Creates a tile at (x, y) occupied by `entity`
     *
     * @param x      - the x coordinate
     * @param y      - the y coordinate
     * @param entity - the entity occupying
     */
    public Tile(int x, int y, Entity entity) {
        this.position = new Position(x, y);
        this.entity = entity;
    }

    public Entity getEntity() {
        return entity;
    }

    public void setEntity(Entity entity) {
        this.entity = entity;
    }

    /**
     * Determines if an entity currently occupies the tile
     *
     * @return whether or not the tile is occupied
     */
    public boolean isOccupied() {
        return this.getEntity() != null;
    }

    @Override
    public String toString() {
        return this.position.toString();
    }
}
=======
import javafx.scene.control.Button;

public class Tile extends Button{
	private boolean bomb = false;
	private boolean hidden = true;
	private int x;
	private int y;
	public boolean isHidden() {
		return hidden;
	}
	public void setHidden(boolean revealed) {
		this.hidden = revealed;
	}
	public Tile(int x, int y) {
		this.setText(" ");
		this.x = x;
		this.y = y;
	}
	public boolean adjacent(Tile tile) {
		return Math.sqrt(Math.pow((getX()-tile.getX()), 2)+Math.pow((getY()-tile.getY()), 2))<2;
	}
	public int getX() {
		return x;
	}
	public int getY() {
		return y;
	}
	public boolean isBomb() {
		return bomb;
	}
	public void setBomb(boolean bomb) {
		this.bomb = bomb;
	}
	
}
>>>>>>> t/main
