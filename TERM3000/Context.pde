import java.util.Stack;

Context context;
Stack<Context> contextHistory;

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
  if (contextHistory.isEmpty()) exit();
  else {
    Context restored = contextHistory.pop();
    if (!restored.hasSize(width, height)) restored.resize(width, height);
    restored.flagEverythingForRepaint();
    repaint_background = true;
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
  context.mousePressed();
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

interface Context {
  boolean hasSize(int _WIDTH, int _HEIGHT);
  void resize(int _WIDTH, int _HEIGHT);
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
}

abstract class ConcreteContext implements Context {
  int WIDTH, HEIGHT;
  ConcreteContext(int _WIDTH, int _HEIGHT) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
  }
  boolean hasSize(int _WIDTH, int _HEIGHT) {
    return WIDTH == _WIDTH && HEIGHT == _HEIGHT;
  }
  void resize(int _WIDTH, int _HEIGHT) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
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
}


// This one's for you, Taj!
interface Contextable {
  Context toContext(int _WIDTH, int _HEIGHT);
}

class BlankContext extends ConcreteContext {
  BlankContext(int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
  }
  void display() {
    background(0);
  }
}
