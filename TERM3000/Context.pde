import java.util.Stack;

Context context = new TestContext(width, height);
Stack<Context> contextHistory = new Stack();

void initializeContext(Context _context) {
  contextHistory = new Stack();
  if (context != null) context.deconstruct();
  context = _context;
  reedraw();
}

// Change current context, but don't change the history
void changeContext(Context _context) {
  if (context != null) context.deconstruct();
  context = _context;
  reedraw();
}

// Change the current context, and push the previous current context to the contextHistory
void pushContext(Context _context) {
  contextHistory.push(context);
  context = _context;
  reedraw();
}

void popContext() {
  if (contextHistory.isEmpty()) {
    tagmanager.save();
    exit();
  } else {
    Context restored = contextHistory.pop();
    if (!restored.hasSize(width, height)) restored.resize(width, height);
    restored.flagEverythingForRepaint();
    //repaint_background = true;
    if (context != null) {
      context.deconstruct();
    }
    context = restored;
    reedraw();
  }
}

void mousePressed() {
  context.mousePressed();
}
void mouseClicked() {
  context.mouseClicked();
}
void mouseReleased() {
  context.mouseReleased();
}
void mouseMoved() {
  context.mouseMoved();
}
void mouseDragged() {
  context.mouseDragged();
}
void mouseWheel(MouseEvent event) {
  context.mouseWheel(event);
}
void keyPressed() {
  if (key == ESC) {
    popContext();
    key = 0;
  } else context.keyPressed();
}
void keyReleased() {
  context.keyReleased();
}
void keyTyped() {
  context.keyTyped();
}

interface Context {
  boolean hasSize(int _WIDTH, int _HEIGHT);
  void resize(int _WIDTH, int _HEIGHT);
  int minWidth();
  int minHeight();
  void deconstruct();
  void flagEverythingForRepaint();
  void display();
  void mousePressed();
  void mouseClicked();
  void mouseReleased();
  void mouseMoved();
  void mouseDragged();
  void mouseWheel(MouseEvent event);
  void keyPressed();
  void keyReleased();
  void keyTyped();
}

abstract class ConcreteContext implements Context {
  int WIDTH, HEIGHT;
  ConcreteContext(int _WIDTH, int _HEIGHT) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
  }
  final boolean hasSize(int _WIDTH, int _HEIGHT) {
    return WIDTH == _WIDTH && HEIGHT == _HEIGHT;
  }
  void resize(int _WIDTH, int _HEIGHT) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
  }
  int minWidth() {
    return 128;
  }
  int minHeight() {
    return 128;
  }
  void deconstruct() {
  }
  void flagEverythingForRepaint() {
  }
  void display() {
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
  }
  void mouseWheel(MouseEvent event) {
  }
  void keyPressed() {
  }
  void keyReleased() {
  }
  void keyTyped() {
  }
}


// This one's for you, Taj!
interface Contextable {
  Context toContext(int _WIDTH, int _HEIGHT);
}

class TestContext extends ConcreteContext {
  String[] lines;
  int pos = 0;
  TestContext(int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
    lines = new String[] {"", "", "", "", "", ""};
  }

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
    addLine("resize: " + _WIDTH + "x"+ _HEIGHT);
  }

  void display() {
    pushStyle();
    pushMatrix();
    noStroke();
    fill(64);
    rect(0, 0, WIDTH, HEIGHT);
    fill(255);
    ellipse(WIDTH*.5, HEIGHT*.5, WIDTH, HEIGHT);
    fill(220);
    ellipse(WIDTH*.5, HEIGHT*.5, minWidth(), minHeight());
    fill(0);
    textAlign(CENTER, CENTER);
    text(join(lines, '\n'), 0, 0, WIDTH, HEIGHT);
    popStyle();
    popMatrix();
  }

  void addLine(String line) {
    lines[pos] = line;
    pos = (pos + 1) % lines.length;
    reedraw();
  }


  void deconstruct() {
    addLine("deconstruct");
  }
  void flagEverythingForRepaint() {
    addLine("flagEverythingForRepaint");
  }
  void mousePressed() {
    addLine("mousePressed: " + mouseX + "," + mouseY);
  }
  void mouseClicked() {
    addLine("mouseClicked: " + mouseX + "," + mouseY);
  }
  void mouseReleased() {
    addLine("mouseReleased: " + mouseX + "," + mouseY);
  }
  void mouseMoved() {
    addLine("mouseMoved: " + mouseX + "," + mouseY);
  }
  void mouseDragged() {
    addLine("mouseDragged: " + mouseX + "," + mouseY);
  }
  void mouseWheel(MouseEvent event) {
    addLine("mouseWheel: " + event.getCount());
  }
  void keyPressed() {
    addLine("keyPressed: " + keyCode + " : " + key);
  }
  void keyReleased() {
    addLine("keyReleased: " + keyCode + " : " + key);
  }
  void keyTyped() {
    addLine("keyTyped: " + keyCode + " : " + key);
  }
}
