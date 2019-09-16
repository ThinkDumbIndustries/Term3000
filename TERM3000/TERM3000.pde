String ROOT = "C:/Users/felix/Pictures/Photos";

int MAX_THUMBNAIL_WORKERS = 4;

TileGrid grid;

void setup() {
  noStroke();
  //size(500, 300);
  fullScreen(2);

  setupThumbnailWorkers();
  loadImages();
  grid = new TileGrid(width, height, 5);
  noLoop();
}

boolean repaint_background = true;

void draw() {
  if (repaint_background) background(0);
  repaint_background = false;
  //noStroke();
  //fill(0, 40);
  //rect(0, 0, width, height);
  grid.display();
  fill(255);
  textSize(20);
  textAlign(LEFT, TOP);
  text(frameCount, 0, 0);
}

void mouseWheel(MouseEvent event) {
  grid.setLine(constrain(event.getCount(), -1, 1) + grid.current_line, false);
}

void keyPressed() { 
  if (key == 'r') {
    for (int i = 0; i < grid.tiles.length; i++) grid.tiles[i].repaint = true;
    repaint_background = true;
    redraw();
  } else if (keyCode == UP) grid.setLine(grid.current_line - 1, false);
  else if (keyCode == DOWN)  grid.setLine(grid.current_line + 1, false);
  else if (key == '+') grid.setTilesPerLine(grid.TILES_PER_LINE - 1, false);
  else if (key == '-') grid.setTilesPerLine(grid.TILES_PER_LINE + 1, false);
  else if (keyCode == 34) grid.setLine(grid.current_line + grid.LINES_PER_SCREEN - 1, false);
  else if (keyCode == 33) grid.setLine(grid.current_line - grid.LINES_PER_SCREEN + 1, false);
}
