class NPC {
 
    int x, y;
    int direction;
    int bombCooldown = 0;
    boolean isDead = false;
    boolean buff2effectNPC = false;
    PImage[][] npcFrames;
    int frameIndex = 0;
    float animTimer = 0;
    int divideheight, dividewidth;
    int explosionrangeNPC =1;
    int maxBombNPC=1;
    int currentBombNPC = 1;
    boolean buff2effect = false;
    boolean SpeedBuff = false;
    int moveDuration = 0;
    int currentMoveStep = 0;
    int preferredDirection = -1;
    float scaleNPC;
    float i =1;// mark as the buff2 effect to make NPC move larger two units at a time
    float currentTimeNPC;
    int moveGap =5;
    int  moveCounter = 0;
    float BubbleSizeNPC;
    
    ArrayList<int[]> NPCbomb = new ArrayList<>();
    ArrayList<int[]> NPCexplosions = new ArrayList<>();
    
    
   
    NPC(int startX, int startY, PImage spriteSheet, int divideheight, int dividewidth) {
         currentTimeNPC = millis();
        x = startX;
        y = startY;
        this.divideheight = divideheight;
        this.dividewidth = dividewidth;

        direction = int(random(divideheight));

        npcFrames = new PImage[divideheight][dividewidth];
        int frameWidth = spriteSheet.width / dividewidth;
        int frameHeight = spriteSheet.height / divideheight;

        for (int d = 0; d < divideheight; d++) {
            for (int f = 0; f < dividewidth; f++) {
                npcFrames[d][f] = spriteSheet.get(f * frameWidth, d * frameHeight, frameWidth, frameHeight);
            }
        }
    }

 void move() {
    if (isDead) return;
      float cur = millis()-currentTimeNPC;
      if(buff2effectNPC){
         i =0.5;
         if(cur>5000){
             i = 0;
             buff2effectNPC = false;
         }
      }
       int[] closestBuff = findNearestBuff(x,y);
       int targetX = playerX;
        int targetY = playerY;
       
        if(closestBuff!= null){targetX = closestBuff[0];targetY = closestBuff[1];
      }
        else{
          targetX = playerX; targetY = playerY;
        }
        if(moveCounter>0){moveCounter--; return;}// we make it only move when moveCOunter==0
        
        else{moveCounter = moveGap;
        int newXnpc = this.x, newYnpc = this.y;
        
        int dx = targetX-this.x;
        int dy = targetY -this.y;
         dx = (dx!=0)?(dx/abs(dx)) : 0;
         dy = (dy!=0)?(dy/abs(dy)) : 0 ;
     
        if(random(1)<0.8){
          if(random(1)<0.5){
             newXnpc += dx;}
             else{
               newYnpc += dy;
             }}
         else{
         
        
        
        direction = int(random(divideheight)); 
        

        if (divideheight == 4) {
            if (direction == 0) newYnpc--;
            if (direction == 1) newXnpc--;
            if (direction == 2) newXnpc++;
            if (direction == 3) newYnpc++;
        }
        if (divideheight == 3) {
            direction = direction %3;
            if(random(1)<0.8){
              newXnpc ++;}
              else{
              newYnpc++;
            }}

        if (newXnpc < 0){newXnpc=0;} 
        if(newXnpc>= 15){newXnpc=14;} 
        if(newYnpc < 0){newYnpc=0;} 
         if(newYnpc >=13){newYnpc=12;} 
    
    
        if(mapGrid[newYnpc][newXnpc]==0){this.x = newXnpc; this.y= newYnpc;}
        else if(mapGrid[newYnpc][newXnpc] == 7||mapGrid[newYnpc][newXnpc] == 8){return;}
        else if(mapGrid[newYnpc][newXnpc] == 4 ||mapGrid[newYnpc][newXnpc] == 5||mapGrid[newYnpc][newXnpc] == 6){
           x = newXnpc;
          y= newYnpc;}
         if(mapGrid[newYnpc][newXnpc] == 4){
        explosionrangeNPC++;  mapGrid[newYnpc][newXnpc] = 0;}
     else if(mapGrid[newYnpc][newXnpc] == 5){
       buff2effectNPC = true;mapGrid[newYnpc][newXnpc] = 0;
     }
     else if(mapGrid[newYnpc][newXnpc] == 6){
       maxBombNPC ++;mapGrid[newYnpc][newXnpc] = 0;}
         if(random(1)<0.5|| isTrapped()){
           if(currentBombNPC<= maxBombNPC){
             mapGrid[this.y][this.x]=8;
             int tempXnpc = this.x;
             int tempYnpc = this.y;
             NPCbomb.add(new int[] {tempXnpc, tempYnpc});
             currentBombNPC ++;
             new Timer().schedule(new TimerTask() {
      public void run() {
        triggerNPCExplosion(tempXnpc,tempYnpc);
      
        
        }
    }, 2000);
        }}
        
   
        
    }}}
    boolean isTrapped() {
    int[][] directions = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
    for (int[] dir : directions) {
        int newX = x + dir[0];
        int newY = y + dir[1];
        if (newX >= 0 && newX < 15 && newY >= 0 && newY < 13 && mapGrid[newY][newX] == 0) {
            return false; 
        }
    }
    return true; }
    void triggerNPCExplosion(int x, int y) {
  
 
   
   
   currentBombNPC--;
  for(int i=1;i<=explosionrangeNPC;i++){
  destroyTile(x, y, NPCbomb);NPCexplosions.add(new int[]{x, y});}
  for(int i=1;i<=explosionrangeNPC;i++){
    if(x+i>=15) break;
    if(mapGrid[y][x+i] == 2){
     destroyTile(x+i, y, NPCbomb);NPCexplosions.add(new int[]{x+i, y});
    break;
  }
  destroyTile(x+i, y, NPCbomb);NPCexplosions.add(new int[]{x+i, y});
  
}  for(int i=1;i<=explosionrangeNPC;i++){
  if((x-i)<0) break;
   if(mapGrid[y][x-i] == 2){
      destroyTile(x-i, y, NPCbomb);
  NPCexplosions.add(new int[]{x-i, y});
    break;
  }
  destroyTile(x-i, y, NPCbomb);
  NPCexplosions.add(new int[]{x-i, y});
 
}  for(int i=1;i<=explosionrangeNPC;i++){
  if(y+i>=13) break;
   if(mapGrid[y+i][x] == 2){
    destroyTile(x, y+i, NPCbomb);NPCexplosions.add(new int[]{x, y+i});
    break;
  }
  destroyTile(x, y+i, NPCbomb);NPCexplosions.add(new int[]{x, y+i});
 
}
 for(int i=1;i<=explosionrangeNPC;i++){
   if(y-i<0) break;
    if(mapGrid[y-i][x] == 2){
      destroyTile(x, y-i, NPCbomb);
  NPCexplosions.add(new int[]{x, y-i});
    break;
  }
  destroyTile(x, y-i, NPCbomb);
  NPCexplosions.add(new int[]{x, y-i});
  
 
}
 
  for(int[] explosion:new ArrayList<>(NPCexplosions)){
  if (isPlayerHit(explosion)) {
    gameOver = true;
  }}
  new Timer().schedule(new TimerTask() {
    public void run() {
      NPCexplosions.clear();
      mapGrid[y][x] = 0;
    }
  }, 500);


}
int[] findNearestBuff(int npcX, int npcY) {
    int[] bestBuff = null;
    int bestDist = Integer.MAX_VALUE;
    int bestPriority = -1;  
    Queue<int[]> queue = new LinkedList<>();
    boolean[][] visited = new boolean[13][15];

    int[][] parent = new int[13][15]; 
    for (int i = 0; i < 13; i++) {
        Arrays.fill(parent[i], -1);
    }

    queue.add(new int[]{npcX, npcY, 0});
    visited[npcY][npcX] = true;

    while (!queue.isEmpty()) {
        int[] current = queue.poll();
        int x = current[0];
        int y = current[1];
        int steps = current[2];

        if (mapGrid[y][x] == 4 || mapGrid[y][x] == 5 || mapGrid[y][x] == 6) {
            int priority = (mapGrid[y][x] == 6) ? 3 : (mapGrid[y][x] == 5) ? 2 : 1;

          
            if (priority > bestPriority || (priority == bestPriority && steps < bestDist)) {
                bestPriority = priority;
                bestDist = steps;
                bestBuff = new int[]{x, y};
            }
        }

        int[][] directions = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
        for (int[] dir : directions) {
            int newX = x + dir[0];
            int newY = y + dir[1];

            if (newX >= 0 && newX < 15 && newY >= 0 && newY < 13 && !visited[newY][newX] && mapGrid[newY][newX] != 7) {
                queue.add(new int[]{newX, newY, steps + 1});
                visited[newY][newX] = true;
                parent[newY][newX] = x * 15 + y;
            }
        }
    }

    if (bestBuff != null) {
        return tracePath(npcX, npcY, bestBuff[0], bestBuff[1], parent);
    }
    return null;
}

int[] tracePath(int startX, int startY, int targetX, int targetY, int[][] parent) {
    int x = targetX, y = targetY;
    
    while (parent[y][x] != -1) {
        int prev = parent[y][x];
        x = prev / 15;
        y = prev % 15;
        if (parent[y][x] == startX * 15 + startY) {
            return new int[]{x, y}; 
        }
    }
    return new int[]{targetX, targetY}; 
}


    void drawNPC() {
        if (isDead) return;
        int safeDirection = constrain(direction, 0, divideheight - 1);
        int safeFrameIndex = constrain(frameIndex, 0, dividewidth - 1);

        image(npcFrames[safeDirection][safeFrameIndex], this.x * tileSize, this.y * tileSize, tileSize, tileSize);
    }

    void checkIfHit() {
        for (int[] explosion : explosions) {
            if (explosion[0] == x && explosion[1] == y) {
                isDead = true;
            }
        }
    }
}
