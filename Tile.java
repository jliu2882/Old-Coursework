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
