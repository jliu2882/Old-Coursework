import java.awt.*;
import java.awt.font.*;
import java.awt.geom.*;
import java.awt.image.BufferedImage;
import java.text.*;
import java.util.*;
import java.util.List; // resolves problem with java.awt.List and java.util.List

/**
 * A class that represents a picture.  This class inherits from 
 * SimplePicture and allows the student to add functionality to
 * the Picture class.  
 * 
 * @author Barbara Ericson ericson@cc.gatech.edu
 */
public class Picture extends SimplePicture 
{
  ///////////////////// constructors //////////////////////////////////
  
  /**
   * Constructor that takes no arguments 
   */
  public Picture ()
  {
    /* not needed but use it to show students the implicit call to super()
     * child constructors always call a parent constructor 
     */
    super();  
  }
  
  /**
   * Constructor that takes a file name and creates the picture 
   * @param fileName the name of the file to create the picture from
   */
  public Picture(String fileName)
  {
    // let the parent class handle this fileName
    super(fileName);
  }
  
  /**
   * Constructor that takes the width and height
   * @param height the height of the desired picture
   * @param width the width of the desired picture
   */
  public Picture(int height, int width)
  {
    // let the parent class handle this width and height
    super(width,height);
  }
  
  /**
   * Constructor that takes a picture and creates a 
   * copy of that picture
   * @param copyPicture the picture to copy
   */
  public Picture(Picture copyPicture)
  {
    // let the parent class do the copy
    super(copyPicture);
  }
  
  /**
   * Constructor that takes a buffered image
   * @param image the buffered image to use
   */
  public Picture(BufferedImage image)
  {
    super(image);
  }
  
  ////////////////////// methods ///////////////////////////////////////
  
  /**
   * Method to return a string with information about this picture.
   * @return a string with information about the picture such as fileName,
   * height and width.
   */
  public String toString()
  {
    String output = "Picture, filename " + getFileName() + 
      " height " + getHeight() 
      + " width " + getWidth();
    return output;
    
  }

  /** Method to set the blue to 0 */
  public void zeroBlue()
  {
    Pixel[][] pixels = this.getPixels2D();
    for (Pixel[] rowArray : pixels)
    {
      for (Pixel pixelObj : rowArray)
      {
        pixelObj.setBlue(0);
      }
    }
  }
  /** Method to set the red to 0 */
  public void zeroRed()
  {
    Pixel[][] pixels = this.getPixels2D();
    for (Pixel[] rowArray : pixels)
    {
      for (Pixel pixelObj : rowArray)
      {
        pixelObj.setRed(0);
      }
    }
  }
  /** Method to set red and green to 0 */
  public void keepBlue(){
    Pixel[][] pixels = this.getPixels2D();
    for(Pixel[] rowArray : pixels){
      for(Pixel pixelObj : rowArray){
        pixelObj.setRed(0);
        pixelObj.setGreen(0);
      }
    }
  }
  /** Method to set blue and green to 0 */
  public void keepRed(){
    Pixel[][] pixels = this.getPixels2D();
    for(Pixel[] rowArray : pixels){
      for(Pixel pixelObj : rowArray){
        pixelObj.setBlue(0);
        pixelObj.setGreen(0);
      }
    }
  }
  /** Method to set red green and blue to their inverse */
  public void negate(){
    Pixel[][] pixels = this.getPixels2D();
    for(Pixel[] rowArray : pixels){
      for(Pixel pixelObj : rowArray){
        pixelObj.setRed(255-pixelObj.getRed());
        pixelObj.setGreen(255-pixelObj.getGreen());
        pixelObj.setBlue(255-pixelObj.getBlue());
      }
    }
  }
  /** Method to set picture to gray with a cool formula :) */
  public void grayscale(){
    Pixel[][] pixels = this.getPixels2D();
    int NumberOfShades = 16;
    for(Pixel[] rowArray : pixels){
      for(Pixel pixelObj : rowArray){
        int ConversionFactor = 255 / (NumberOfShades - 1);
        int AverageValue = (pixelObj.getRed() + pixelObj.getGreen() + pixelObj.getBlue())/3;
        int gray = (int) ((AverageValue / ConversionFactor) + 0.5) * ConversionFactor;
        pixelObj.setRed(gray);
        pixelObj.setGreen(gray);
        pixelObj.setBlue(gray);
      }
    }
  }
  /** Method to fix the picture if it is 'underwater' */
  public void fixUnderwater(){
    Pixel[][] pixels = this.getPixels2D();
    for(Pixel[] rowArray : pixels){
      for(Pixel pixelObj : rowArray){
        pixelObj.setBlue(pixelObj.getRed());
        pixelObj.setGreen(pixelObj.getRed());
      }
    }
  }
  
  /** Method that mirrors the picture around a 
    * vertical mirror in the center of the picture
    * from left to right */
  public void mirrorVertical()
  {
    Pixel[][] pixels = this.getPixels2D();
    Pixel leftPixel = null;
    Pixel rightPixel = null;
    int width = pixels[0].length;
    for (int row = 0; row < pixels.length; row++)
    {
      for (int col = 0; col < width / 2; col++)
      {
        leftPixel = pixels[row][col];
        rightPixel = pixels[row][width - 1 - col];
        rightPixel.setColor(leftPixel.getColor());
      }
    } 
  }
  public void mirrorVerticalRightToLeft()
  {
    Pixel[][] pixels = this.getPixels2D();
    Pixel leftPixel = null;
    Pixel rightPixel = null;
    int width = pixels[0].length;
    for (int row = 0; row < pixels.length; row++)
    {
      for (int col = 0; col < width / 2; col++)
      {
        leftPixel = pixels[row][col];
        rightPixel = pixels[row][width - 1 - col];
        rightPixel.setColor(rightPixel.getColor());
      }
    }
  }
  public void mirrorHorizontal()
  {
      Pixel[][] pixels = this.getPixels2D();
      Pixel topPixel = null;
      Pixel bottomPixel = null;
      int height = pixels.length;
      for (int row = 0; row <height / 2; row++)
      {
          for (int col = 0; col < pixels[0].length; col++)
          {
              topPixel = pixels[row][col];
              bottomPixel = pixels[height - 1 - row][col];
              bottomPixel.setColor(topPixel.getColor());
          }
      }
  }
    public void mirrorHorizontalBotToTop()
    {
        Pixel[][] pixels = this.getPixels2D();
        Pixel topPixel = null;
        Pixel bottomPixel = null;
        int height = pixels.length;
        for (int row = height/2 -1; row >= 0; row--)
        {
            for (int col = pixels[0].length-1; col >= 0; col--)
            {
                bottomPixel = pixels[row][col];
                topPixel = pixels[height - 1 - row][col];
                topPixel.setColor(bottomPixel.getColor());
            }
        }
    }
    public void mirrorDiagonal() //
    {
        Pixel[][] pixels = this.getPixels2D();
        Pixel topRightPixel = null;
        Pixel bottomLeftPixel = null;
        int maxLength;
        if (pixels.length < pixels[0].length) { maxLength = pixels.length; }
        else {maxLength = pixels[0].length; }

        for (int row = 0; row < maxLength; row++)
        {
            for (int col = row; col < maxLength; col++)
            {
                topRightPixel = pixels[row][col];
                bottomLeftPixel = pixels[col][row];
                bottomLeftPixel.setColor(topRightPixel.getColor());
            }
        }
    }

  
  /** Mirror just part of a picture of a temple */
  public void mirrorTemple()
  {
    int mirrorPoint = 276;
    Pixel leftPixel = null;
    Pixel rightPixel = null;
    int count = 0;
    Pixel[][] pixels = this.getPixels2D();

    // loop through the rows
    for (int row = 27; row < 97; row++)
    {
      // loop from 13 to just before the mirror point
      for (int col = 13; col < mirrorPoint; col++)
      {
        
        leftPixel = pixels[row][col];      
        rightPixel = pixels[row]                       
                         [mirrorPoint - col + mirrorPoint];
        rightPixel.setColor(leftPixel.getColor());
      }
    }
  }
  
  /** copy from the passed fromPic to the
    * specified startRow and startCol in the
    * current picture
    * @param fromPic the picture to copy from
    * @param startRow the start row to copy to
    * @param startCol the start col to copy to
    */
  public void copy(Picture fromPic, 
                 int startRow, int startCol)
  {
    Pixel fromPixel = null;
    Pixel toPixel = null;
    Pixel[][] toPixels = this.getPixels2D();
    Pixel[][] fromPixels = fromPic.getPixels2D();
    for (int fromRow = 0, toRow = startRow; 
         fromRow < fromPixels.length &&
         toRow < toPixels.length; 
         fromRow++, toRow++)
    {
      for (int fromCol = 0, toCol = startCol; 
           fromCol < fromPixels[0].length &&
           toCol < toPixels[0].length;  
           fromCol++, toCol++)
      {
        fromPixel = fromPixels[fromRow][fromCol];
        toPixel = toPixels[toRow][toCol];
        toPixel.setColor(fromPixel.getColor());
      }
    }   
  }
  public void newcopy(Picture fromPic, int startRow, int endRow, int startCol, int endCol)
  {
    Pixel fromPixel = null;
    Pixel toPixel = null;
    Pixel[][] toPixels = this.getPixels2D();
    Pixel[][] fromPixels = fromPic.getPixels2D();
    for (int fromRow = 0, toRow = startRow;
         fromRow < fromPixels.length &&
                 toRow < endRow;
         fromRow++, toRow++)
    {
      for (int fromCol = 0, toCol = startCol;
           fromCol < fromPixels[0].length &&
                   toCol < endCol;
           fromCol++, toCol++)
      {
        fromPixel = fromPixels[fromRow][fromCol];
        toPixel = toPixels[toRow][toCol];
        toPixel.setColor(fromPixel.getColor());
      }
    }
  }

  /** Method to create a collage of several pictures */
  public void createCollage()
  {
    {
      Picture flower1 = new Picture("flower1.jpg");
      Picture flower2 = new Picture("flower2.jpg");
      this.newcopy(flower1,0,100, 0, 100);
      int mirrorPoint = 98;
      Pixel rightPixel = null;
      Pixel leftPixel = null;
      Pixel[][] pixels = this.getPixels2D();
      for (int row = 0; row < 98; row++)
      {
        for (int col = 0; col < 88; col++)
        {
          rightPixel = pixels[row][col];
          leftPixel = pixels[mirrorPoint - row + mirrorPoint][col];
          leftPixel.setColor(rightPixel.getColor());
        }
      }
      Picture flowerNoBlue = new Picture(flower2);
      flowerNoBlue.zeroBlue();
      this.newcopy(flowerNoBlue,300,350,80,500);
      Picture flowerinverse = new Picture(flower2);
      flowerinverse.invert();
      this.newcopy(flowerinverse, 100, 300, 80, 300);
      this.write("collage.jpg");
    }
  }
  public void invert()
  {
    Pixel[][] pixels = this.getPixels2D();
    for (int row = 0; row < pixels.length; row++)
    {
      for (int col = 0; col < pixels[0].length; col++)
      {
        int red = 255 - pixels[row][col].getRed();
        int green = 255 - pixels[row][col].getGreen();
        int blue = 255 - pixels[row][col].getBlue();

        Color newColor = new Color(red, green, blue);

        pixels[row][col].setColor(newColor);
      }
    }
  }

  /** Method to show large changes in color 
    * @param edgeDist the distance for finding edges
    */
  public void edgeDetection(int edgeDist)
  {
      Pixel leftPixel = null;
      Pixel rightPixel = null;
      Pixel[][] pixels = this.getPixels2D();
      Color rightColor = null;
      for (int row = 0; row < pixels.length; row++)
      {
          for (int col = 0;
               col < pixels[0].length-1; col++)
          {
              leftPixel = pixels[row][col];
              rightPixel = pixels[row][col+1];
              rightColor = rightPixel.getColor();
              if (leftPixel.colorDistance(rightColor) >
                      edgeDist)
                  leftPixel.setColor(Color.BLACK);
              else
                  leftPixel.setColor(Color.WHITE);
          }
      }
      for (int col = 0; col < pixels[0].length; col++)
      {
          for (int row = 0; row < pixels.length-1; row++)
          {
              leftPixel = pixels[row][col];
              rightPixel = pixels[row+1][col];
              rightColor = rightPixel.getColor();
              if (leftPixel.colorDistance(rightColor) >
                      edgeDist)
                  leftPixel.setColor(Color.BLACK);
          }
      }
  }
  /** used top to bottom without right to left*/
  public void edgeDetection2(int edgeDist)
  {
     Pixel leftPixel = null;
     Pixel rightPixel = null;
     Pixel[][] pixels = this.getPixels2D();
     Color rightColor = null;
     for (int col = 0; col < pixels[0].length; col++)
     {
         for (int row = 0; row < pixels.length-1; row++)
         {
             leftPixel = pixels[row][col];
             rightPixel = pixels[row+1][col];
             rightColor = rightPixel.getColor();
             if (leftPixel.colorDistance(rightColor) >
                     edgeDist)
                 leftPixel.setColor(Color.BLACK);
             else
                 leftPixel.setColor(Color.WHITE);
         }
     }
  }
  
  
  /* Main method for testing - each class in Java can have a main 
   * method 
   */
  public static void main(String[] args) 
  {
    Picture beach = new Picture("beach.jpg");
    beach.explore();
    beach.zeroBlue();
    beach.explore();
  }
  
} // this } is the end of class Picture, put all new methods before this
