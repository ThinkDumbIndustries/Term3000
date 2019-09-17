class FullView extends Context {
  TFile[] tfiles;
  int indx;

  PImage full;

  FullView(int _WIDTH, int _HEIGHT, TFile[] _tfiles, int _indx) {
    super(_WIDTH, _HEIGHT);
    this.tfiles = _tfiles;
    this.indx = _indx;
    loadFull();
  }

  void loadFull() {
    full = loadImage(ROOT + "/" + tfiles[indx].location);
  }  

  void keyPressed() {
    int old_indx = indx;
    if (keyCode == LEFT) indx = max(0, indx - 1);
    else if (keyCode == RIGHT) indx = max(0, indx + 1);
    if (old_indx != indx) {
      loadFull();
      reedraw();
    }
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
