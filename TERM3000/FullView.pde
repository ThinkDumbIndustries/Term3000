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

  void keyPressed() {
    int old_indx = indx;
    if (keyCode == LEFT) indx = max(0, indx - 1);
    else if (keyCode == RIGHT) indx = min(indx + 1, files.length - 1);
    if (old_indx == indx) return;
    ctx = tfiles[indx].toContext(WIDTH, HEIGHT);
    reedraw();
  }

  void display() {
    ctx.display();
  }
}
