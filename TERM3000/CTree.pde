class TreeTag extends ConcreteContext {
  TreeTag(int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
    cam = new Camera(WIDTH, HEIGHT);
  }

  Camera cam;

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
    cam = new Camera(WIDTH, HEIGHT, cam);
  }
  void deconstruct() {
  }
  void flagEverythingForRepaint() {
  }

  Tag tagHovered = null;
  Tag tagDragged = null;
  Tag tagClicked = null;

  void display() {
    pushMatrix();
    background(255);
    strokeWeight(0.1);
    cam.apply();

    tagmanager.update();
    cam.updateMouse();

    if (!mousePressed) {
      tagHovered = null;
      tagDragged = null;
      for (Tag t : tagmanager.alltags) if (dist(cam.mx, cam.my, t.x, t.y) < 0.15) tagHovered = t;
    } else {
      if (tagHovered != null) {
        tagDragged = null;
        if (mouseButton == RIGHT) for (Tag t : tagmanager.alltags) {
          if (!tagmanager.isASubtagOf(tagHovered.id, t.id) &&
            !tagmanager.isASubtagOf(t.id, tagHovered.id) &&
            dist(cam.mx, cam.my, t.x, t.y) < 0.3) tagDragged = t;
        }
        if (tagDragged != null) {
          stroke(255, 0, 0);
          displayConnection(tagHovered, tagDragged);
          Tag t = tagHovered;
          Tag p = tagDragged;
          float dx = p.x - t.x;
          float dy = p.y - t.y;
          float d = sqrt(dx*dx + dy*dy);
          float f = ((d - 1) * ATTRCACTION) / d;
          t.apply(dx*f, dy*f);
          f *= -0.1;
          p.apply(dx*f, dy*f);
        } else {
          float dx = cam.mx - tagHovered.x;
          float dy = cam.my - tagHovered.y;
          float d = sqrt(dx*dx + dy*dy);
          float f = ((d - 0) * ATTRCACTION * 5) / d;
          tagHovered.apply(dx*f, dy*f);
        }
      }
    }

    for (Tag t : tagmanager.alltags) {
      for (Tag p : t.parents) {
        int a = t.id;
        int b = p.id;
        if (tagHovered != null) {
          int x = tagHovered.id;
          if (tagmanager.isASubtagOf(a, x) && tagmanager.isASubtagOf(b, x)) stroke(#1FFF1C);
          else if (tagmanager.isASubtagOf(x, a) && tagmanager.isASubtagOf(x, b)) stroke(#FF731C);
          else stroke(128);
        } else stroke(128);
        displayConnection(t, p);
      }
    }
    noStroke();
    strokeWeight(0.03);
    for (Tag t : tagmanager.alltags) {
      if (tagHovered != null) {
        if (t == tagHovered) stroke(#FEFF2E);
        else if (tagmanager.isASubtagOf(t.id, tagHovered.id)) stroke(#1FFF1C);
        else if (tagmanager.isASubtagOf(tagHovered.id, t.id)) stroke(#FF731C);
        else noStroke();
      } else noStroke();
      if (t == tagClicked) {
        fill(255);
        stroke(0);
      } else fill(0);
      ellipse(t.x, t.y, 0.3, 0.3);
      pushMatrix();
      translate(t.x, t.y);
      float zoom = 200;
      scale(1.0 / zoom);
      textAlign(CENTER, CENTER);
      if (t == tagClicked) fill(0);
      else fill(255);
      rectMode(CENTER);
      text(t.name, 0, 0, 0.3 * zoom, 0.3 * zoom);
      popMatrix();
    }
    popMatrix();
    //if (tagmanager.needsReedraw())
    reedraw();
  }
  void displayConnection(Tag t, Tag p) {
    line(t.x, t.y, p.x, p.y);
    float dx = p.x - t.x;
    float dy = p.y - t.y;
    final int N = 3;
    final float OUT = 0.13;
    pushStyle();
    strokeCap(SQUARE);
    for (int i = 1; i < N; i++) {
      pushMatrix();
      translate(t.x + dx*float(i)/N, t.y + dy*float(i)/N);
      line(0, 0, OUT*(-dx-dy), OUT*(-dy+dx));
      line(0, 0, OUT*(-dx+dy), OUT*(-dy-dx));
      popMatrix();
    }
    popStyle();
  }
  void mousePressed() {
  }
  void mouseClicked() {
    tagClicked = null;
    if (mouseButton == CENTER) {
      tagClicked = tagmanager.addTag("???");
      cam.updateMouse();
      tagClicked.x = cam.mx;
      tagClicked.y = cam.my;
    } else if (mouseButton == LEFT) {
      if (tagHovered != null) tagClicked = tagHovered;
    }
  }
  void mouseReleased() {
    if (tagHovered != null && tagDragged != null) {
      tagmanager.makeASubtagOf(tagHovered.id, tagDragged.id);
      tagmanager.reduce();
      tagmanager.printt();
    }
  }
  void mouseMoved() {
  }
  void mouseDragged() {
    if (tagHovered == null) cam.mouseDragged();
  }
  void mouseWheel(MouseEvent event) {
    cam.mouseWheel(event);
  }
  void keyPressed() {
  }
  void keyTyped() {
    if (tagClicked != null) {
      if (key == DELETE) {
        if (tagmanager.isLonely(tagClicked)) tagmanager.makeLonely(tagClicked);
        else tagmanager.delete(tagClicked);
      } else {
        String name = tagClicked.name; 
        if (key == BACKSPACE) {
          println("JM");
          if (tagClicked.name.length() == 0) return;
          tagClicked.name = tagClicked.name.substring(0, tagClicked.name.length() - 1);
          reedraw();
        } else if (key != CODED && isAllowed(key)) {
          tagClicked.name = name + str(key);
          reedraw();
        }
        //println(keyCode, int(key), key, isAllowed(key));
      }
    }
  }

  boolean isAllowed(char c) {
    return c != ',';
    //(c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == ' ';
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
