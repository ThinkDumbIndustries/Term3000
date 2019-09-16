//String ROOT = "C:/Users/felix/Pictures/Photos";
String ROOT = "C:/Users/Maximilien/Pictures/Photos";

int MAX_THUMBNAIL_WORKERS = 4;

TileGrid grid;

PApplet SKETCH = this;

void setup() {
  //noStroke();
  size(500, 300);
  //fullScreen();

  setupThumbnailWorkers();
  loadFiles();
  grid = new TileGrid(width, height, 5);
}

boolean repaint_background = true;

void draw() {
  if (!reedraw) {
    noLoop();
    return;
  } 
  loop();
  reedraw = false;
  // Do the actual redraw
  if (repaint_background) background(0);
  repaint_background = false;
  //noStroke();
  //fill(0, 40);
  //rect(0, 0, width, height);
  grid.display();
  pushStyle();
  fill(255);
  textSize(20);
  textAlign(LEFT, TOP);
  text(frameCount, 0, 0);
  popStyle();
}

boolean reedraw = true;
void reedraw() {
  reedraw = true;
  redraw();
}

void mouseWheel(MouseEvent event) {
  grid.setLine(constrain(event.getCount(), -1, 1) + grid.current_line, false);
}

void keyPressed() {
  if (key == 'r') {
    for (int i = 0; i < grid.tiles.length; i++) grid.tiles[i].repaint = true;
    repaint_background = true;
    reedraw();
  } else if (keyCode == UP) grid.setLine(grid.current_line - 1, false);
  else if (keyCode == DOWN)  grid.setLine(grid.current_line + 1, false);
  else if (key == '+') grid.setTilesPerLine(grid.TILES_PER_LINE - 1, false);
  else if (key == '-') grid.setTilesPerLine(grid.TILES_PER_LINE + 1, false);
  else if (keyCode == 34) grid.setLine(grid.current_line + grid.LINES_PER_SCREEN - 1, false); // Page Up
  else if (keyCode == 33) grid.setLine(grid.current_line - grid.LINES_PER_SCREEN + 1, false); // Page Down
  else if (keyCode == 36) grid.setLine(0, false);             // Home
  else if (keyCode == 35) grid.setLine(grid.MAX_LINE, false); // End
}
