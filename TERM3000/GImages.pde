class TImage extends TThumbable {
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

class ImageContext extends Context {
  PImage full;

  ImageContext(TImage timage, int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
    full = loadImage(ROOT + "/" + timage.location);
  }

  void display() {
    fill(0);
    noStroke();
    rect(0, 0, WIDTH, HEIGHT);
    pushMatrix();
    translate(WIDTH*.5, HEIGHT*.5);
    float scale = min(float(WIDTH)/full.width, float(HEIGHT)/full.height);
    scale(scale);
    imageMode(CENTER);
    image(full, 0, 0);
    popMatrix();
  }
}
