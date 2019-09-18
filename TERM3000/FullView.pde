class FullView extends Context {
  TFile[] tfiles;
  int indx;
  Context ctx;

  FullView(int _WIDTH, int _HEIGHT, TFile[] _tfiles, int _indx) {
    super(_WIDTH, _HEIGHT);
    this.tfiles = _tfiles;
    this.indx = _indx;
    ctx = tfiles[indx].toContext(WIDTH, HEIGHT);
  }

  void deconstruct() {
    ctx.deconstruct();
  }

  void resize(int _WIDTH, int _HEIGHT) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
    ctx.resize(WIDTH, HEIGHT);
  }

  void mousePressed() {
    ctx.mousePressed();
  }
  void mouseClicked() {
    ctx.mouseClicked();
  }
  void mouseReleased() {
    ctx.mouseReleased();
  }
  void mouseMoved() {
    ctx.mouseMoved();
  }
  void mouseDragged() {
    ctx.mouseDragged();
  }
  void mouseWheel(MouseEvent event) {
    ctx.mouseWheel(event);
  }
  void keyPressed() {
    int old_indx = indx;
    if (keyCode == LEFT) indx = max(0, indx - 1);
    else if (keyCode == RIGHT) indx = min(indx + 1, files.length - 1);
    else {
      ctx.keyPressed();
      return;
    }
    if (old_indx == indx) return;
    ctx.deconstruct();
    ctx = tfiles[indx].toContext(WIDTH, HEIGHT);
    reedraw();
  }
  void keyReleased() {
    ctx.keyReleased();
  }

  void display() {
    ctx.display();
  }
}
