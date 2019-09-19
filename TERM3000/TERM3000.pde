//String ROOT = "C:/Users/felix/Pictures/Photos";
String ROOT = "C:/Users/Maximilien/Pictures/Photos";
int MAX_THUMBNAIL_WORKERS = 4;

PApplet SKETCH = this;

import processing.javafx.PSurfaceFX;
import javafx.stage.Stage;
import javafx.scene.canvas.Canvas;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;

void setup() {
  //size(800, 300, FX2D);
  fullScreen(FX2D);
  surface.setResizable(true);

  //noStroke();

  setupThumbnailWorkers();
  loadFiles();
  initializeContext(new TileGrid(width, height, 5));
  //pushContext(new FullView(width, height, files, 137)); // temporary; for faster development
  //initializeContext(HorizontalSplit(width, height, 10, new TestContext(width, height), 1.0, new TestContext(width, height), 1.0));
  //initializeContext(HorizontalSplit(width, height, 10, new TestContext(width, height), 1.0, new TestContext(width, height), 1.0, new TestContext(width, height), 1.0));
  //initializeContext(HorizontalSplitTest(width, height, 10, 5));
  //initializeContext(VerticalSplitTest(width, height, 10, 5));
  //initializeContext(HorizontalSplit(width, height, 10, new TileGrid(width, height, 5), 1.0, new TileGrid(width, height, 5), 1.0));
  initializeContext(GridSplitTest(width, height, 10, 5, 5));

  PSurfaceFX fx = (PSurfaceFX)surface;
  Canvas canvas = (Canvas) fx.getNative();
  InvalidationListener listener = new InvalidationListener() {
    public void invalidated(Observable o) {
      resize_happened = true;
      reedraw();
    }
  };
  canvas.widthProperty().addListener(listener);
  canvas.heightProperty().addListener(listener);
}

boolean resize_happened = true;
boolean repaint_background = true;

void draw() {
  if (!reedraw) {
    noLoop();
    return;
  } 
  reedraw = false;
  loop();

  if (resize_happened) context.resize(width, height);
  resize_happened = false;

  context.display();

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

void movieEvent(Movie m) {
  m.read();
  reedraw();
}
