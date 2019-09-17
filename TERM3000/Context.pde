import java.util.Stack;

Context context;
Stack<Context> contextHistory;

void initializeContext(Context _context) {
  contextHistory = new Stack();
  context = _context;
}

// Change current context, but don't change the history
void changeContext(Context _context) {
  context = _context;
}

// Change the current context, and push the previous current context to the contextHistory
void addContext(Context _context) {
  contextHistory.push(context);
  context = _context;
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
void mouseDragged() {
  context.mouseDragged();
}
void mouseWheel(MouseEvent event) {
  context.mouseWheel(event);
}
void keyPressed() {
  context.keyPressed();
}
void keyReleased() {
  context.keyReleased();
}

abstract class Context {
  void display() {
  }
  void mousePressed() {
  }
  void mouseClicked() {
  }
  void mouseReleased() {
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
