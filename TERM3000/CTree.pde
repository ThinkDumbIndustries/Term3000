class TreeTag extends ConcreteContext {
  TreeTag(int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
  }

  Camera cam = new Camera();

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
  }
  void deconstruct() {
  }
  void flagEverythingForRepaint() {
  }
  void display() {
    pushMatrix();
    background(255);
    stroke(128);
    strokeWeight(0.1);
    cam.apply(WIDTH, HEIGHT);
    for (Tag t : tagmanager.alltags) {
      for (Tag p : t.parents) {
        line(t.x, t.y, p.x, p.y);
      }
    }
    noStroke();
    fill(0);
    for (Tag t : tagmanager.alltags) {
      ellipse(t.x, t.y, 0.3, 0.3);
    }
    popMatrix();
    reedraw();
  }
  void mousePressed() {
  }
  void mouseClicked() {
  }
  void mouseReleased() {
  }
  void mouseMoved() {
  }
  void mouseDragged() {
    cam.mouseDragged();
  }
  void mouseWheel(MouseEvent event) {
    cam.mouseWheel(event);
  }
  void keyPressed() {
  }
  void keyTyped() {
    //String name = currentTag.name; 
    //if (key == BACKSPACE) {
    //  println("JM");
    //  if (currentTag.name.length() == 0) return;
    //  currentTag.name = currentTag.name.substring(0, currentTag.name.length() - 1);
    //  reedraw();
    //} else if (key != CODED) { //true || isAllowed(key)) {
    //  currentTag.name = name + str(key);
    //  reedraw();
    //}
    //println(keyCode, int(key), key, isAllowed(key));
  }

  boolean isAllowed(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == ' ';
  }

  void keyReleased() {
  }
}




class TreeTagOld extends ConcreteContext {
  TreeTagOld(int _WIDTH, int _HEIGHT) {
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
      Tag t = currentTag.parents.get(i);
      float x = map(i, -1, currentTag.parents.size(), 0, WIDTH);
      float y = HEIGHT * 0.2;
      stroke(0);
      line(x, y, cx, cy);
      for (int i_ = 0; i_ < t.parents.size(); i_++) {
        Tag t_ = t.parents.get(i_);
        float x_ = map(map(i_, -1, t.parents.size(), i-0.5, i+0.5), -1, currentTag.parents.size(), 0, WIDTH);
        float y_ = HEIGHT * 0.0;
        line(x, y, x_, y_);
      }
      fill(128);
      noStroke();
      rect(x, y, 50, 20);
      fill(0);
      text(t.name, x, y);
    }

    for (int i = 0; i < currentTag.children.size(); i++) {
      Tag t = currentTag.children.get(i);
      float x = map(i, -1, currentTag.children.size(), 0, WIDTH);
      float y = HEIGHT * 0.8;
      stroke(0);
      line(x, y, cx, cy);
      for (int i_ = 0; i_ < t.children.size(); i_++) {
        Tag t_ = t.children.get(i_);
        float x_ = map(map(i_, -1, t.children.size(), i-0.5, i+0.5), -1, currentTag.children.size(), 0, WIDTH);
        float y_ = HEIGHT * 1.0;
        line(x, y, x_, y_);
      }
      fill(128);
      noStroke();
      rect(x, y, 50, 20);
      fill(0);
      text(t.name, x, y);
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
  void keyTyped() {
    String name = currentTag.name; 
    if (key == BACKSPACE) {
      println("JM");
      if (currentTag.name.length() == 0) return;
      currentTag.name = currentTag.name.substring(0, currentTag.name.length() - 1);
      reedraw();
    } else if (key != CODED) { //true || isAllowed(key)) {
      currentTag.name = name + str(key);
      reedraw();
    }
    println(keyCode, int(key), key, isAllowed(key));
  }

  boolean isAllowed(char c) {
    //println(c);
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == ' ';
  }

  void keyReleased() {
  }
}
