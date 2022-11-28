public class Coin extends AnimatedSprite{
  public Coin(PImage img, float scale){
    super (img, scale);
    standNeutral = new PImage[4];
    standNeutral[0] = loadImage("coin1.png");
    standNeutral[1] = loadImage("coin2.png");
    standNeutral[2] = loadImage("coin3.png");
    standNeutral[3] = loadImage("coin4.png");
    currentImages= standNeutral;
    
  }
}
