class TreeTag extends ConcreteContext {
  TreeTag(int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
    currentTag = tagmanager.alltags.get(2);
  }

  Tag currentTag;

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
  }
  void deconstruct() {
  }
  void flagEverythingForRepaint() {
  }
  void display() {
    background(255);
    float cx = WIDTH *.5;
    float cy = HEIGHT*.5;
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    for (int i = 0; i < currentTag.parents.size(); i++) {
      float x = map(i, -1, currentTag.parents.size(), 0, WIDTH);
      float y = HEIGHT * 0.2;
      println(x, y);
      stroke(0);
      line(x, y, cx, cy);
      fill(128);
      noStroke();
      rect(x, y, 50, 20);
      fill(0);
      text(currentTag.parents.get(i).name, x, y);
    }

    for (int i = 0; i < currentTag.children.size(); i++) {
      float x = map(i, -1, currentTag.children.size(), 0, WIDTH);
      float y = HEIGHT * 0.8;
      println(x, y);
      stroke(0);
      line(x, y, cx, cy);
      fill(128);
      noStroke();
      rect(x, y, 50, 20);
      fill(0);
      text(currentTag.children.get(i).name, x, y);
    }
    fill(128);
    noStroke();
    rect(cx, cy, 50, 20);
    fill(0);
    text(currentTag.name, cx, cy);
  }
  void mousePressed() {
    if (mouseY < HEIGHT*0.5) {
      int id = round(map(mouseX, 0, WIDTH, -1, currentTag.parents.size()));
      if (id < 0 || id >= currentTag.parents.size()) return;
      currentTag = currentTag.parents.get(id);
    } else {
      int id = round(map(mouseX, 0, WIDTH, -1, currentTag.children.size()));
      if (id < 0 || id >= currentTag.children.size()) return;
      currentTag = currentTag.children.get(id);
    }
    reedraw();
  }
  void mouseClicked() {
  }
  void mouseReleased() {
  }
  void mouseMoved() {
  }
  void mouseDragged() {
  }
  void mouseWheel(MouseEvent event) {
  }
  void keyPressed() {
  }
  void keyReleased() {
  }
}
