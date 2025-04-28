import processing.sound.*;

import sprites.*;
import sprites.maths.*;
import sprites.utils.*;
import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;


int bombtype = 0;
int cur = 0;
int currentBomb=0;
int currentSong = 1;
int direction = 0;  
int explosionrange =1;
int frameIndex = 0;
int maxBomb=1;
int mouseclick=0;
int playerX =7 , playerY = 1;
int time = 0;
int[][] mapGrid = {
  {2, 0, 0, 0, 2, 0, 2, 2, 2, 0, 2, 0, 0, 0, 2},  
  {0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 1, 0, 0},  
  {0, 2, 2, 0, 2, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0},
  {0, 0, 0, 0, 2, 2, 0, 2, 0, 2, 2, 0, 0, 0, 0},
  {0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 0},
  {2, 2, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 2},
  {2, 0, 0, 2, 0, 2, 0, 3, 0, 2, 0, 2, 0, 0, 2},
  {2, 2, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 2},
  {0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 0},
  {0, 0, 0, 0, 2, 2, 0, 2, 0, 2, 2, 0, 0, 0, 0},
  {0, 2, 2, 0, 2, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0},
  {0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 1, 0, 0},  
  {2, 0, 0, 0, 2, 0, 2, 2, 2, 0, 2, 0, 0, 0, 2}, 
};
int tileSize = 50;  
boolean buff2effect = true;
boolean canMove = false;
boolean changemusic = false;
boolean check1 = false;
boolean check2 = false;
boolean check3 = false;
boolean gameOver = false;
boolean gameoverplay = false;
boolean gameoverplay2 = false;
boolean gameoverplay3 = false;
boolean gameoverplay4 = false;
boolean isBoosting = false;
boolean isMoving = false;
boolean isPaused = false;
boolean isRestarting = false;
boolean restart = false;
boolean result;
PImage spriteSheet, brick, plant, bombImg, explosionImg,cactus,back,buff1,buff2,buff3,npc1sheet,npc2sheet,npc3sheet,npc4sheet,defeat,victory,UI1,guide,Restart;
PImage[][] playerFrames = new PImage[4][4];
PImage[] dynamicbomb = new PImage[4];
PImage NPCBomb;
float animTimer = 0;
float lastBomb = 0;
float changebomb = 200;
float currentTime;
float speedX = 0;
float speedY = 0;
float setspeed = 2;

int restartButtonX = 200;
int restartButtonY = 450; 
int restartButtonWidth = 350;
int restartButtonHeight = 100;
int restartAnimationTimer = 0;

SoundFile file;
SoundFile file2;
SoundFile file3;
SoundFile win;
SoundFile lose;
SoundFile begin;
SoundFile ready;
NPC npc1,npc2,npc3;
ArrayList<int[]> bombs = new ArrayList<int[]>();
ArrayList<int[]> explosions = new ArrayList<int[]>();




void setup() {
   file = new SoundFile(this,"snow.mp3");
   //file.play();
   file2 = new SoundFile(this,"chinatown.mp3");
   file3 = new SoundFile(this,"buff.mp3");
   win = new SoundFile(this, "Victory.mp3");
   lose = new SoundFile(this, "Lose.mp3");
   begin = new SoundFile(this, "MZTKN.mp3");
   ready = new SoundFile(this,"ready.mp3");
   
  size(750,650);
  noStroke();
  npc1sheet = loadImage("kenan2.png");
  npc2sheet = loadImage("npc1_proc.png");
  npc3sheet = loadImage("SPONGE_resized.png");
  npc4sheet = loadImage("zha2_resized.png");
  spriteSheet = loadImage("image66.png");
  brick = loadImage("brick.png");
  plant = loadImage("plant.png");
  bombImg = loadImage("ball.png");
  buff1 = loadImage("buff1.png");
  buff2 = loadImage("buff2.png");
  buff3 = loadImage("buff3.png");
  defeat = loadImage("Defeat.png");
  victory = loadImage("Victory.png");
  guide = loadImage("resized_image.png");
  UI1 = loadImage("UI1.png");
  NPCBomb = loadImage("NPCBomb.png");
  Restart = loadImage("RESTART.png");
  npc1 = new NPC(1,6, npc1sheet, 4,3);
  npc2 = new NPC(13,6, npc2sheet, 4,4);
  npc3 = new NPC(7,11, npc3sheet, 4,4);
  
  
  explosionImg = loadImage("explosion.png");
  cactus = loadImage("1.png");
  back = loadImage("background.png");


  
  int frameWidth = spriteSheet.width / 4;
  int frameHeight = spriteSheet.height / 4;
  

  
  for (int d = 0; d < 4; d++) {
    for (int f = 0; f < 4; f++) {
      playerFrames[d][f] = spriteSheet.get(f * frameWidth, d * frameHeight, frameWidth, frameHeight);
    }
  }
  int averageheight = bombImg.height/4;
  for(int i=0;i<4;i++){
      dynamicbomb[i] = bombImg.get(0,averageheight*0, bombImg.width, bombImg.width);
   
  
  }
  
  currentTime = millis();
  
}
boolean ifGridAllZero(){
   for(int[] map:mapGrid){
    for(int num: map){
        if(num!=0){ return false;}
    
    }
  }
  return true;
}

void mouseClicked(){
   mouseclick ++;
   if(mouseclick==1)
   check1 = true;
   if(mouseclick==2) 
   check2 = true;
    if (gameOver && 
       mouseX >= restartButtonX && mouseX <= restartButtonX + restartButtonWidth &&
       mouseY >= restartButtonY && mouseY <= restartButtonY + restartButtonHeight) {
       
       isRestarting = true;
       restartAnimationTimer = millis(); 
   }
}
   
  
  



void draw() {
   if(!check1){
     fill(0,0,0,150);
     rect(0,0,200,500);
      currentSong = -1;
     image(UI1, 0,0);
     textSize(80);
     fill(30,10,20);
     text("Click to start", 150,600);
     if(currentSong==-1&&!gameoverplay2){
   begin.play();
 gameoverplay2 = true;}}
 if(mouseclick==1){
   //begin.stop();
   stroke(0);
   textSize(50);
   image(guide,0,0);
   fill(50,51,81);
   rect(0,380, 750,250);
   textSize(30);
   fill(255);
   text("Press SPACE to place bubbles. Break walls for random buffs",0,450);
   fill(255,0,0);
   text("Win until you destroy all NPCs",200,500);
   text("Click to start", 550,300);}
   if(mouseclick==2&&!gameoverplay3){
     begin.stop();
     currentSong = -2;
     if(currentSong==-2&&!gameoverplay3)
     ready.play();
     gameoverplay3 = true;
     mouseclick++;
  
  }
  
 
 else{
   if(mouseclick>=3){
     if(!ready.isPlaying()&&!gameoverplay4){
        begin.stop();
      file.play();
      file.loop();
      currentSong =2;
      gameoverplay4 = true;
    }
    if(currentSong==2 && !file.isPlaying()&&!file2.isPlaying()){
    file2.play();
    file2.loop();
    currentSong =1;
  }
  
  background(0);
  back.resize(750,650);
  image(back,0,0);
  // This is to draw the map based on the coordinates recorded in the matrix
  for (int row = 0; row < 13; row++) {
    for (int col = 0; col < 15; col++) {
      int tile = mapGrid[row][col];
      if (tile == 1) image(plant, col * tileSize, row * tileSize, tileSize, tileSize);
      if (tile == 2) image(brick, col * tileSize, row * tileSize, tileSize, tileSize);
      if(tile == 3) image(cactus, col * tileSize, row * tileSize, tileSize, tileSize);
      if(tile==4) image(buff1, col * tileSize, row * tileSize, tileSize, tileSize); //buff1
      if(tile==5) image(buff2, col * tileSize, row * tileSize, tileSize, tileSize);//buff 2
      if(tile==6) image(buff3, col * tileSize, row * tileSize, tileSize, tileSize);// buff3
    }
  }
    npc1.drawNPC();
    npc2.drawNPC();
    npc3.drawNPC();
    npc1.move();
    npc2.move();
    npc3.move();

    npc1.checkIfHit();
    npc2.checkIfHit();
    npc3.checkIfHit();


  if(millis()-lastBomb>100){
    lastBomb = millis();
    bombtype = (bombtype+1)%4;
  }
 
  float scale;
  float a = random(0,1);
  for (int[] bomb : new ArrayList<>(bombs)) {
    
    scale = 1+0.2*sin(frameCount*0.03);
    float BubbleSize = tileSize*scale;
    float offset = (tileSize-BubbleSize)/2;
    image(bombImg, bomb[0] * tileSize, bomb[1] * tileSize, BubbleSize+offset-5, BubbleSize+offset-2);
    time+=1*random(1,2);
  }
   for (int[] bomb : new ArrayList<>(npc1.NPCbomb)) {
    
    scale = 1+0.2*sin(frameCount*0.03);
    float BubbleSize2 = tileSize*scale;
    float offset2 = (tileSize-BubbleSize2)/2;
    image(NPCBomb, bomb[0] * tileSize, bomb[1] * tileSize, BubbleSize2+offset2-5, BubbleSize2+offset2-2);
    time+=1*random(1,2);
  }
   for (int[] bomb : new ArrayList<>(npc2.NPCbomb)) {
    
    scale = 1+0.2*sin(frameCount*0.03);
    float BubbleSize3 = tileSize*scale;
    float offset3 = (tileSize-BubbleSize3)/2;
    image(NPCBomb, bomb[0] * tileSize, bomb[1] * tileSize, BubbleSize3+offset3-5, BubbleSize3+offset3-2);
    time+=1*random(1,2);
  }
   for (int[] bomb : new ArrayList<>(npc3.NPCbomb)) {
    
    scale = 1+0.2*sin(frameCount*0.03);
    float BubbleSize4 = tileSize*scale;
    float offset4 = (tileSize-BubbleSize4)/2;
    image(NPCBomb, bomb[0] * tileSize, bomb[1] * tileSize, BubbleSize4+offset4-5, BubbleSize4+offset4-2);
    time+=1*random(1,2);
  }
 

  for (int[] explosion : new ArrayList<>(explosions)) {
    image(explosionImg, explosion[0] * tileSize, explosion[1] * tileSize, tileSize, tileSize);}
   for (int[] explosion : new ArrayList<>(npc1.NPCexplosions)) {
    image(explosionImg, explosion[0] * tileSize, explosion[1] * tileSize, tileSize, tileSize);}
     for (int[] explosion : new ArrayList<>(npc2.NPCexplosions)) {
    image(explosionImg, explosion[0] * tileSize, explosion[1] * tileSize, tileSize, tileSize);}
     for (int[] explosion : new ArrayList<>(npc3.NPCexplosions)) {
    image(explosionImg, explosion[0] * tileSize, explosion[1] * tileSize, tileSize, tileSize);}
   
 
  if(npc1.isDead&&npc2.isDead&&npc3.isDead){
    gameOver = true;
    result = true;
  
  }
  if (!gameOver) {
    if (isMoving) {
      if (millis() - animTimer > 200) {
        animTimer = millis();
        frameIndex = (frameIndex +1) % 4;
      }
    } else {
      frameIndex = 0;
    }
   
    image(playerFrames[direction][frameIndex], playerX*tileSize-10 , playerY * tileSize-20, tileSize+20, tileSize+20);
  } else {
    
    if(npc1.isDead&&npc2.isDead&&npc3.isDead){
      currentSong = 4;
      fill(255, 0, 0);
    textSize(32);
    file.stop();
    file2.stop();
    file3.stop();
    if(currentSong==4&&!gameoverplay){ win.play(); currentSong = 0;gameoverplay=true;}
   
    
    image(victory, 230,100,300,300);
     float restartScale = (isRestarting && millis() - restartAnimationTimer < 150) ? 0.9 : 1.0;
            int adjustedWidth = (int) (restartButtonWidth * restartScale);
            int adjustedHeight = (int) (restartButtonHeight * restartScale);
            int adjustedX = restartButtonX + (restartButtonWidth - adjustedWidth) / 2;
            int adjustedY = restartButtonY + (restartButtonHeight - adjustedHeight) / 2;
            
            image(Restart, adjustedX, adjustedY, adjustedWidth, adjustedHeight);
   
    if (isRestarting && millis() - restartAnimationTimer >= 150) {
                restartGame();
            }

  }
  else{
     currentSong =3;
    fill(255, 0, 0);
    textSize(32);
    file.stop();
    file2.stop();
    file3.stop();
    if(currentSong==3&&!gameoverplay){ lose.play(); currentSong = 0;gameoverplay=true;}
    //text("GAME OVER", width / 3, height / 2);
    
    image(defeat, 230,100,300,300);
    float restartScale = (isRestarting && millis() - restartAnimationTimer < 150) ? 0.9 : 1.0;
            int adjustedWidth = (int) (restartButtonWidth * restartScale);
            int adjustedHeight = (int) (restartButtonHeight * restartScale);
            int adjustedX = restartButtonX + (restartButtonWidth - adjustedWidth) / 2;
            int adjustedY = restartButtonY + (restartButtonHeight - adjustedHeight) / 2;
            
            image(Restart, adjustedX, adjustedY, adjustedWidth, adjustedHeight);
             if (isRestarting && millis() - restartAnimationTimer >= 150) {
                restartGame();
            }
  
  }

}}}}
void restartGame(){
  isRestarting = false;
  mouseclick = 3;  
    bombtype = 0;
    cur = 0;
    currentBomb = 0;
    currentSong = 1;
    direction = 0;  
    explosionrange = 1;
    frameIndex = 0;
    maxBomb = 1;
    playerX = 7;
    playerY = 1;
    time = 0;
    mapGrid = new int[][]{
      {2, 0, 0, 0, 2, 0, 2, 2, 2, 0, 2, 0, 0, 0, 2},  
      {0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 1, 0, 0},  
      {0, 2, 2, 0, 2, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0},
      {0, 0, 0, 0, 2, 2, 0, 2, 0, 2, 2, 0, 0, 0, 0},
      {0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 0},
      {2, 2, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 2},
      {2, 0, 0, 2, 0, 2, 0, 3, 0, 2, 0, 2, 0, 0, 2},
      {2, 2, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 2},
      {0, 2, 0, 2, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 0},
      {0, 0, 0, 0, 2, 2, 0, 2, 0, 2, 2, 0, 0, 0, 0},
      {0, 2, 2, 0, 2, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0},
      {0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 1, 0, 0},  
      {2, 0, 0, 0, 2, 0, 2, 2, 2, 0, 2, 0, 0, 0, 2}, 
    };
  
   
    buff2effect = true;
    canMove = false;
    changemusic = false;
    check1 = false;
    check2 = false;
    check3 = false;
    gameOver = false;
    gameoverplay = false;
    gameoverplay2 = false;
    gameoverplay3 = false;
    gameoverplay4 = false;
    isBoosting = false;
    isMoving = false;
    isPaused = false;
    restart = false;
    

    bombs.clear();
    explosions.clear();
    npc1.NPCbomb.clear();
    npc1.NPCexplosions.clear();
    npc2.NPCbomb.clear();
    npc2.NPCexplosions.clear();
    npc3.NPCbomb.clear();
    npc3.NPCexplosions.clear();
    
   
    npc1 = new NPC(1,6, npc1sheet, 4,3);
    npc2 = new NPC(13,6, npc2sheet, 4,4);
    npc3 = new NPC(7,11, npc3sheet, 4,4);

    
    file.stop();
    file2.stop();
    file3.stop();
    win.stop();
    lose.stop();
    begin.stop();
    ready.stop();
    

    currentSong = 2;
}


void keyPressed() {
  if(key == 'R' ||key == 'r')  {
    restartGame();
  }
  
  
  if (gameOver|| !canMove) return;
  canMove = buff2effect ? true:false;
  
  
  int newX = playerX, newY = playerY;
  
  if (key == 's'|| keyCode==DOWN) { newY++; direction = 0; }  
  if (key == 'a' || keyCode==LEFT) { newX--; direction = 1; }  
  if (key == 'd'||keyCode == RIGHT) { newX++; direction= 2; }  
  if (key == 'w'||keyCode==UP) { newY--; direction = 3; }  
  if(newY<0){newY=0;}
  if(newY>=13){newY=12;}
  if(newX<0){newX=0;}
  if(newX>=15){newX=14;}
 
  if (mapGrid[newY][newX] == 0) {
    playerX = newX;
    playerY = newY;
    isMoving = true;
  } 
  else if(mapGrid[newY][newX]==7){return;}
  else if(mapGrid[newY][newX] == 4 ||mapGrid[newY][newX] == 5||mapGrid[newY][newX] == 6){
      playerX = newX;
      playerY = newY;
      isMoving = true;
      file3.play();
     if(mapGrid[newY][newX] == 4){
      explosionrange++;  mapGrid[newY][newX] = 0;}
     else if(mapGrid[newY][newX] == 5){
       buff2effect = true;mapGrid[newY][newX] = 0;
     }
     else if(mapGrid[newY][newX] == 6){
       maxBomb ++;mapGrid[newY][newX] = 0;}
  }
  else {
    isMoving = false;
  } if (key == ' ') {
    if(currentBomb<maxBomb){
      mapGrid[playerY][playerX] = 7;
    int tempX = playerX;
    int tempY = playerY;
    bombs.add(new int[]{tempX, tempY});
    currentBomb ++;
    new Timer().schedule(new TimerTask() {
      public void run() {
        triggerExplosion(tempX, tempY);
        //,explosionrange,explosions,bombs);
      }
    }, 3000);
  }
}

  
float cur = millis()-currentTime;
 if(cur>5000){
   buff2effect = false;
   currentTime = millis();
 }

}
void keyReleased() {
  canMove = true;
  isMoving = false;
}

void triggerExplosion(int x, int y) {
  
  currentBomb--;
  
   
   
  
  
  for(int i=1;i<=explosionrange;i++){
  destroyTile(x, y, bombs);explosions.add(new int[]{x, y});}
  for(int i=1;i<=explosionrange;i++){
    if(x+i>=15) break;
    if(mapGrid[y][x+i] == 2){
     destroyTile(x+i, y, bombs);explosions.add(new int[]{x+i, y});
    break;
  }
  destroyTile(x+i, y, bombs);explosions.add(new int[]{x+i, y});
  
}  for(int i=1;i<=explosionrange;i++){
  if((x-i)<0) break;
   if(mapGrid[y][x-i] == 2){
      destroyTile(x-i, y, bombs);
  explosions.add(new int[]{x-i, y});
    break;
  }
  destroyTile(x-i, y, bombs);
  explosions.add(new int[]{x-i, y});
 
}  for(int i=1;i<=explosionrange;i++){
  if(y+i>=13) break;
   if(mapGrid[y+i][x] == 2){
    destroyTile(x, y+i, bombs);explosions.add(new int[]{x, y+i});
    break;
  }
  destroyTile(x, y+i, bombs);explosions.add(new int[]{x, y+i});
 
}
 for(int i=1;i<=explosionrange;i++){
   if(y-i<0) break;
    if(mapGrid[y-i][x] == 2){
      destroyTile(x, y-i, bombs);
  explosions.add(new int[]{x, y-i});
    break;
  }
  destroyTile(x, y-i, bombs);
  explosions.add(new int[]{x, y-i});
 
}
 
  for(int[] explosion:new ArrayList<>(explosions)){
  if (isPlayerHit(explosion)) {
    gameOver = true;
  }}
 
  new Timer().schedule(new TimerTask() {
    public void run() {
      explosions.clear();
      mapGrid[y][x] = 0;
    }
  }, 500);
}

boolean destroyTile(int x, int y,ArrayList<int[]> bombs) {
   bombs.removeIf(b -> b[0]==x&&b[1]==y);
   int bufftype = 0;
  if (x < 0 || x >= 15 || y < 0 || y >= 13) return false;
  if (mapGrid[y][x] == 2) {mapGrid[y][x] = 0;
  float a = random(1);
  if(a<0.2){
      bufftype =4;}
    else if(a>0.8){bufftype =5;return false;}
     else if(a>0.5&&a<0.6){bufftype =6;}
     if (mapGrid[y][x] == 0) {
            mapGrid[y][x] = bufftype;
        }
      return false;
  }
  return false;
  }
  


boolean isPlayerHit(int[] explosion) {
      if(explosion[0]==playerX && explosion[1]==playerY){
        return true;
      }
      return false;
}
