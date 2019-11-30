import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.imaging.jpeg.JpegMetadataReader;
import com.drew.imaging.jpeg.JpegProcessingException;
import com.drew.imaging.jpeg.JpegSegmentMetadataReader;
import com.drew.metadata.exif.ExifReader;
import com.drew.metadata.iptc.IptcReader;

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
  size(800, 600, FX2D);
  //fullScreen(FX2D);
  surface.setResizable(true);

  setupThumbnailWorkers();
  loadDates();

  initializeContext(new DateNavigatorContext(width, height));

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
//boolean repaint_background = true;

void draw() {
  if (!reedraw) {
    noLoop();
    return;
  }
  reedraw = false;
  loop();

  if (width < context.minWidth() || height < context.minHeight()) {
    width = max(width, context.minWidth());
    height = max(height, context.minHeight());
    surface.setSize(width, height);
    resize_happened = true;
  }
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
