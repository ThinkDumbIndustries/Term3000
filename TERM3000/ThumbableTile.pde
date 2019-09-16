import java.util.concurrent.atomic.AtomicInteger;
import java.util.Queue;
import java.util.concurrent.PriorityBlockingQueue;

import processing.video.*;

class ThumbableTile extends Tile implements Comparable<ThumbableTile> {
  TThumbable tfile;
  PImage thumbnail;

  final int ERROR = 0;
  final int WAITING = 1;
  final int LOADING = 2;
  final int SHRINKING = 3;
  final int DONE = 4;
  int status;
  int workerID;
  int priority;
  int id;

  ThumbableTile(TThumbable _image, int _id) {
    this.tfile = _image;
    this.id = _id;
    this.priority = id;
    addToThumbnailWorkerQueue(this);
    status = WAITING;
  }

  public int compareTo(ThumbableTile other) {
    return this.priority - other.priority;
  }

  void display(int x, int y, int w, int h) {
    if (!repaint) return;
    repaint = false;

    if (status == ERROR) fill(255, 0, 0);
    else if (status == WAITING) fill(64);
    else if (status == LOADING) fill(128);
    else if (status == SHRINKING) fill(200);
    else if (status == DONE) {
      fill(0);
      noStroke();
      rect(0, 0, w, h);
      pushMatrix();
      translate(w*.5, h*.5);
      float sc = min(float(w)/thumbnail.width, float(h)/thumbnail.height);
      scale(sc);
      imageMode(CENTER);
      image(thumbnail, 0, 0);
      popMatrix();
      return;
    }
    priority = -frameCount*100 + id;
    updatePriorityThumbabletile(this);

    rect(0, 0, w, h);
    pushStyle();
    fill(0);
    textAlign(CENTER, CENTER);
    if (status >= LOADING) text(str(workerID), 0, 0, w, h/2);
    fill(255);
    text(str(priority), 0, h/2, w, h/2);
    popStyle();
  }
}

void setupThumbnailWorkers() {
  thumbnailWorkers = new ThumbnailWorker[MAX_THUMBNAIL_WORKERS];
  for (int i = 0; i < MAX_THUMBNAIL_WORKERS; i++) {
    thumbnailWorkers[i] = new ThumbnailWorker(i);
    thumbnailWorkers[i].start();
  }
}

void addToThumbnailWorkerQueue(ThumbableTile tile) {
  ThumbabletilesToLoad.add(tile);
}

ThumbableTile pollNextThumbabletileToLoad() {
  return ThumbabletilesToLoad.poll();
}

void updatePriorityThumbabletile(ThumbableTile t) {
  if (ThumbabletilesToLoad.remove(t)) ThumbabletilesToLoad.add(t);
}

ThumbnailWorker[] thumbnailWorkers;
Queue<ThumbableTile> ThumbabletilesToLoad = new PriorityBlockingQueue();

class ThumbnailWorker extends Thread {
  int workerID;
  ThumbableTile tile;

  ThumbnailWorker(int _workerID) {
    this.workerID = _workerID;
  }

  void sleeep(int milis) {
    try {
      sleep(milis);
    }
    catch(Exception e) {
    }
  }

  public void run() {
    while (true) {
      for (int i = 0; tile == null && i < 100; i++) {
        tile = pollNextThumbabletileToLoad();
        if (tile == null) sleeep(10);
      }
      while (tile == null) {
        tile = pollNextThumbabletileToLoad();
        if (tile == null) sleeep(1000);
      }

      tile.workerID = this.workerID;
      File thumbnail = new File(tile.tfile.getThumbnailAbsoluteLocation());
      if (!thumbnail.exists()) {

        PImage full;

        String runtimeClassName = tile.tfile.getClass().getSimpleName();
        if (runtimeClassName.equals("TImage")) full = loadImg(ROOT + "/" + tile.tfile.location);
        else if (runtimeClassName.equals("TMovie")) {
          // Movie stuffs!
          Movie mov = new Movie(SKETCH, ROOT + "/" + tile.tfile.location);
          mov.play();
          while (!mov.available()) sleeep(10);
          mov.read();
          mov.stop();
          full = mov;
        } else {
          println("RUNTIME ERROR!!!");
          println("No implementation provided for generating a thumbail for TFiles of type "+runtimeClassName);
          full = createImage(400, 300, RGB);
          for (int i = 0; i < full.pixels.length; i++) full.pixels[i] = color(random(255)); // let's have some fun, eyy
          // I don't know of a gracefull way to throw exceptions, especially within a thread...
        }

        // SHRINK
        setStatus(tile.SHRINKING);

        int scale = floor(sqrt(full.pixels.length / 80000));
        int nw = full.width / scale;
        int nh = full.height / scale;
        tile.thumbnail = createImage(nw, nh, RGB);

        //println("scaling by factor of scale " + scale);
        //println("shrinking "+tile.image.location);
        //println("src: "+full.width+"x"+full.height);
        //println("new: "+nw+"x"+nh);
        //println("comp: "+(scale*nw)+"x"+(scale*nh));
        println("x"+scale+" : "+full.width+"x"+full.height+" => "+nw+"x"+nh);

        full.resize(nw, nh);
        tile.thumbnail = full.copy();

        setStatus(tile.DONE);

        //SAVE
        full.save(thumbnail.getAbsolutePath());
        g.removeCache(full);
        full = null;
        System.gc();
      } else {
        // Load thumbnail
        tile.thumbnail = loadImg(thumbnail.getAbsolutePath());
        setStatus(tile.DONE);
      }
      tile = null;
    }
  }

  void setStatus(int status) {
    tile.status = status;
    tile.repaint = true;
    if (tile.visible) reedraw();
  }

  PImage loadImg(String str) {
    // LOAD
    setStatus(tile.LOADING);

    //println("loading "+tile.image.location);
    PImage full = loadImage(str);
    return full;
  }
}
