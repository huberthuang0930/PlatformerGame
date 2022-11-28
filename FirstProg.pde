final static float MOVE_SPEED=5;
final static float SPRITE_SCALE=50.0/128;
final static float SPRITE_SIZE=50;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED=17;

final static float RIGHT_MARGIN=400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING=1;
final static int LEFT_FACING=2;

final static float WIDTH=SPRITE_SIZE*16;
final static float HEIGHT=SPRITE_SIZE*12;
final static float GROUND_LEVEL= HEIGHT-SPRITE_SIZE;

Player p;
PImage snow, crate, red_brick, brown_brick,gold,spider,player;
ArrayList<Sprite>platforms;
ArrayList<Sprite>coins;
Enemy enemy;

int numCoins;

float view_x=0;
float view_y=0;

void setup() {
  size(800, 600);
  imageMode(CENTER);
  player=loadImage("player.png");
  p=new Player(player,0.8);
  p.setBottom(GROUND_LEVEL);
  p.center_x=100;
  //p.change_x=0;
  //p.change_y=0;
  platforms=new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  numCoins=0;
  
  gold=loadImage("coin1.png");
  spider = loadImage("spider_walk_right1.png");
  red_brick = loadImage("red_brick.png");
  brown_brick=loadImage("brown_brick.png");
  crate = loadImage("crate.png");
  snow = loadImage("snow.png");
  createPlatforms  ("Map.csv");
}
void draw() {
  background(255);
  scroll();
  p.display();
  p.updateAnimation();
  
  resolvePlatformCollisions(p,platforms);
  for (Sprite s : platforms)
    s.display();
  for (Sprite c : coins){
    c.display();
    ((AnimatedSprite)c).updateAnimation();
  }
  enemy.display();
  enemy.update();
  enemy.updateAnimation();
}
void scroll(){
  float right_boundary= view_x+width-RIGHT_MARGIN;
  if(p.getRight()>right_boundary){
    view_x+=p.getRight()-right_boundary;
  }
  float left_boundary= view_x+LEFT_MARGIN;
  if(p.getLeft()<left_boundary){
    view_x-=left_boundary-p.getLeft();
  }
  float bottom_boundary= view_y+height-VERTICAL_MARGIN;
  if(p.getBottom()>bottom_boundary){
    view_y+=p.getBottom()-bottom_boundary;
  }
  float top_boundary= view_y+VERTICAL_MARGIN;
  if(p.getTop()<top_boundary){
    view_y-=top_boundary-p.getTop();
  }
  translate(-view_x,-view_y);
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  s.center_y+=5;
  ArrayList<Sprite> col_list = checkCollisionList(s,walls);
  s.center_y-=5;
  if(col_list.size()>0){
    return true;
  }
  else{
    return false; 
  }
}
public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  s.change_y+= GRAVITY;
  s.center_y+=s.change_y;
  ArrayList<Sprite> col_list= checkCollisionList(s,walls);
  if(col_list.size()>0){
    Sprite collided=col_list.get(0);
    if(s.change_y>0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y<0){
      s.setTop(collided.getBottom());
    }
    s.change_y=0;
  }
  s.center_x+=s.change_x;
  col_list= checkCollisionList(s,walls);
  if(col_list.size()>0){
    Sprite collided=col_list.get(0);
    if(s.change_x>0){
      s.setRight(collided.getLeft());
    }
    else if(s.change_x<0){
      s.setLeft(collided.getRight());
    }
  }
}
void createPlatforms(String filename) {
  String []lines = loadStrings(filename);
  for (int row=0; row<lines.length; row++) {
    String[]values=split(lines[row], ",");
    for (int col=0; col<values.length; col++) {
      if (values[col].equals("1")) {
        Sprite s=new Sprite(red_brick, SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2+col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2+row*SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("2")) {
        Sprite s=new Sprite(snow, SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2+col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2+row*SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("3")) {
        Sprite s=new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2+col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2+row*SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("4")) {
        Sprite s=new Sprite(crate, SPRITE_SCALE);
        s.center_x=SPRITE_SIZE/2+col*SPRITE_SIZE;
        s.center_y=SPRITE_SIZE/2+row*SPRITE_SIZE;
        platforms.add(s);
      }
      else if (values[col].equals("5")) {
        Coin c=new Coin(gold, SPRITE_SCALE);
        c.center_x=SPRITE_SIZE/2+col*SPRITE_SIZE;
        c.center_y=SPRITE_SIZE/2+row*SPRITE_SIZE;
        platforms.add(c);
      }
      else if(values[col].equals("6")){
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + 4 * SPRITE_SIZE;
        enemy = new Enemy(spider, 50/72.0, bLeft, bRight);
        enemy.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        enemy.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
      }
    }
  }
}
void keyPressed() {
  if (keyCode == RIGHT) {
    p.change_x=MOVE_SPEED;
  } else if (keyCode == LEFT) {
    p.change_x=-MOVE_SPEED;
  } 
  else if (keyCode==UP&& isOnPlatforms(p, platforms)){
    p.change_y=-JUMP_SPEED;
  }
}
void keyReleased() {
  if (keyCode == RIGHT) {
    p.change_x=0;
  } else if (keyCode == LEFT) {
    p.change_x=0;
  } else if (keyCode == UP) {
    p.change_y=0;
  } else if (keyCode == DOWN) {
    p.change_y=0;
  }
}
public boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap =s1.getRight()<=s2.getLeft()||s1.getLeft()>=s2.getRight();
  boolean noYOverlap =s1.getBottom()<=s2.getTop()||s1.getTop()>=s2.getBottom();
  if(noXOverlap||noYOverlap){
    return false;
  }
  else{
    return true;
  }
}
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p:list){
    if(checkCollision(s,p)){
      collision_list.add(p);
    }
  
  }
  return collision_list;
}
