/*
G prefix for 'groupment of classes', notably:
 + class TImage extends TThumbable 
 + class ImageContext extends ConcreteContext
 */

class TImage extends ThumbableFile {
  TImage(String _location) {
    this.location = _location;
  }

  ThumbableTile makeTile(int id) {
    return new ThumbableTile(this, id);
  }

  ImageContext toContext(int _WIDTH, int _HEIGHT) {
    return new ImageContext(this, _WIDTH, _HEIGHT);
  }
}

class ImageContext extends ConcreteContext {
  PImage full;
  float scale;

  ImageContext(TImage timage, int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
    full = loadImage(ROOT + "/" + timage.location);
    scale = min(float(WIDTH)/full.width, float(HEIGHT)/full.height);
  }

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
    scale = min(float(WIDTH)/full.width, float(HEIGHT)/full.height);
  }

  void display() {
    fill(0);
    noStroke();
    rect(0, 0, WIDTH, HEIGHT);
    pushMatrix();
    translate(WIDTH*.5, HEIGHT*.5);
    scale(scale);
    imageMode(CENTER);
    image(full, 0, 0);
    popMatrix();
  }
}
