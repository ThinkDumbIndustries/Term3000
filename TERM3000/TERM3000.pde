//String ROOT = "C:/Users/felix/Pictures/Photos";
String ROOT = "C:/Users/Maximilien/Pictures/Photos";
int MAX_THUMBNAIL_WORKERS = 4;

PApplet SKETCH = this;

void setup() {
  //noStroke();
  size(500, 300);
  //fullScreen();

  setupThumbnailWorkers();
  loadFiles();
  initializeContext(new TileGrid(width, height, 5));
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

  context.display();
  // grid.display();

  showFrameCount();
}

void showFrameCount() {
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
