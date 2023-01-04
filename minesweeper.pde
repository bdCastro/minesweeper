int gridSize = 25;
int nMines = 75;

color lGreen = color(0, 160, 0);
color dGreen = color(0, 120, 0);
color grey = color(150, 150, 150);

int[][] clicked = new int[gridSize][gridSize];
int[][] mines = new int[gridSize][gridSize];
boolean[][] flags = new boolean[gridSize][gridSize];

int tamCell;

void populateMines() {
  // 0 nothing, -1 mine
  for(int i = 0; i < nMines; i++) {
    int x = (int) random(gridSize);
    int y = (int) random(gridSize);
    mines[x][y] = -1;
  }
  
  for(int i = 0; i < gridSize; i++) {
    for(int j = 0; j < gridSize; j++) {
      if(mines[i][j] == -1) continue;
      int count = 0;
      
      if(i-1 >= 0 && mines[i-1][j] == -1) count++;
      if(i+1 < gridSize && mines[i+1][j] == -1) count++;
      if(j-1 >= 0 && mines[i][j-1] == -1) count++;
      if(j+1 < gridSize && mines[i][j+1] == -1) count++;
      
      if(i-1 >= 0 && j-1 >= 0 && mines[i-1][j-1] == -1) count++;
      if(i-1 >= 0 && j+1 < gridSize && mines[i-1][j+1] == -1) count++;
      if(i+1 < gridSize && j-1 >= 0 && mines[i+1][j-1] == -1) count++;
      if(i+1 < gridSize && j+1 < gridSize && mines[i+1][j+1] == -1) count++;

      mines[i][j] = count;
    }
  }
}

void setup() {
  size(500, 500);
  tamCell = width/gridSize;
  populateMines();
}

void draw() {
  background(255);
  drawGrid();
}

void mouseReleased() {
  int x = mouseX/tamCell;
  int y = mouseY/tamCell;
  
  //clicked[mouseX/tamCell][mouseY/tamCell] = 1;
  if(mouseButton == RIGHT) {
    flags[x][y] = !flags[x][y];
    return;
  }
  
  if(flags[x][y]) return;
  
  if(mines[x][y] == 0)
    click(x, y);
  else {
    clicked[x][y] = 1;
  }
}

void click(int x, int y) {
  if(clicked[x][y] == 1) return;
  clicked[x][y] = 1;
  
  if(mines[x][y] != 0) return;
    
  if(x-1 >= 0) click(x-1, y);
  if(x+1 < gridSize) click(x+1, y);
  if(y-1 >= 0) click(x, y-1);
  if(y+1 < gridSize) click(x, y+1);
      
  if(x-1 >= 0 && y-1 >= 0) click(x-1, y-1);
  if(x-1 >= 0 && y+1 < gridSize) click(x-1, y+1);
  if(x+1 < gridSize && y-1 >= 0) click(x+1, y-1);
  if(x+1 < gridSize && y+1 < gridSize) click(x+1, y+1);
    
  //if(x+1 >= 0 && x+1 < gridSize && mines[x+1][y] == 0) click(x+1, y);
  //if(x-1 >= 0 && x-1 < gridSize && mines[x-1][y] == 0) click(x-1, y);
  //if(y+1 >= 0 && y+1 < gridSize && mines[x][y+1] == 0) click(x, y+1);
  //if(y-1 >= 0 && y-1 < gridSize && mines[x][y-1] == 0) click(x, y-1);
}

void drawGrid() {
  for(int i = 0; i < gridSize; i++) {
    for(int j = 0; j < gridSize; j++) {
      drawCell(i, j);
    }
  }
}

void drawCell(int x, int y) {
  push();
  color cellColor = ((x+y) % 2) == 1 ? lGreen : dGreen;
  stroke(127);
  fill(clicked[x][y] == 1 ? grey : cellColor);
  translate(x*tamCell, y*tamCell);
  rect(0, 0, tamCell, tamCell);
  
  push();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  translate(tamCell/2, tamCell/2);
  textSize(18);
  fill(0);
  
  if(clicked[x][y] == 1 && mines[x][y] != -1 && mines[x][y] != 0)
    text(mines[x][y], 0 - 1, 0 - 2);
    
  pop();
  
  if(clicked[x][y] == 1 && mines[x][y] == -1) {
    fill(200, 0, 0);
    ellipse(tamCell/2, tamCell/2, tamCell * 0.4, tamCell * 0.4);
  }
  
  if(flags[x][y]) {
    fill(200, 0, 0);
    noStroke();
    rect(tamCell/4, tamCell/4, tamCell * 0.5, tamCell * 0.5);
  }
  
  pop();
}
