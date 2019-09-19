abstract class SplitContextHandler extends ConcreteContext {
  static final int
    FOCUS_ON_HOVER = 0, 
    FOCUS_ON_CLICK = 1; // Not totally fleshed out yet, although this is a good start for futur expansion
  int focusMode = FOCUS_ON_HOVER;
  int focusedId = 0;
  int hoveredId = -1;

  int DIVIDER_THICKNESS;
  int dividerId = -1;
  boolean dividerPressed = false;

  int count; // number of contexts
  Context[] ctxs;
  int[] sizes;
  //int[] poses;

  SplitContextHandler(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, int _count, Context[] _ctxs, int[] _sizes) {
    super(_WIDTH, _HEIGHT);
    this.DIVIDER_THICKNESS = _DIVIDER_THICKNESS;
    this.count = _count;
    this.ctxs = _ctxs;
    this.sizes = _sizes;
    if (ctxs.length != count) throw new IllegalArgumentException("ctxs.length != count");
    if (sizes.length != count) throw new IllegalArgumentException("sizes.length != count");
    int total = (count - 1) * DIVIDER_THICKNESS;
    for (int i = 0; i < count; i++) {
      if (sizes[i] < minSizee(ctxs[i])) throw new IllegalArgumentException("sizes[i] < getSizee(ctxs[i])");
      resizee(ctxs[i], sizes[i]);
      total += sizes[i];
    }
    if (total != getSizee()) throw new IllegalArgumentException("sizes does not sum up to WIDTH");
  }

  void setFocusMode(int mode) {
    this.focusMode = mode;
  }

  abstract int getSizee();
  abstract void resizee(Context ctx, int size);
  abstract int minSizee(Context ctx);
  abstract int getMouse(); // what luck that mouseX and mouseY are global and mutable!
  abstract void setMouse(int val);
  abstract void translatee(int pos);
  abstract void displayDivider();

  void addMouse(int offset) {
    setMouse(getMouse() + offset);
  }

  void mousePressed() {
    dividerPressed = dividerId != -1; 
    if (focusMode == FOCUS_ON_CLICK) focusedId = hoveredId;
    if (!dividerPressed) ctxs[focusedId].mousePressed();
  }
  void mouseReleased() {
    if (!dividerPressed) ctxs[focusedId].mouseReleased();
    dividerPressed = false;
  }
  void mouseClicked() {
    ctxs[focusedId].mouseClicked(); // this might be dangerous. It could cause clicks outside the screen
  }
  void mouseMoved() {
    dividerId = -1;
    hoveredId = -1;
    int temp = getMouse();
    for (int i = 0; i < count; i++) {
      if (getMouse() < sizes[i]) {
        ctxs[i].mouseMoved();
        if (focusMode == FOCUS_ON_HOVER) focusedId = i;
        else hoveredId = i;
      } else if (getMouse() < sizes[i] + DIVIDER_THICKNESS) dividerId = i;
      else {
        addMouse( - sizes[i] - DIVIDER_THICKNESS);
        continue;
      }
      break;
    }
    setMouse(temp);
  }
  void mouseDragged() {
    if (dividerPressed) {
    } else ctxs[focusedId].mouseDragged();
  }
  void mouseWheel(MouseEvent event) {
    ctxs[focusedId].mouseWheel(event);
  }
  void keyPressed() {
    ctxs[focusedId].keyPressed();
  }
  void keyReleased() {
    ctxs[focusedId].keyReleased();
  }

  void display() {
    pushMatrix();
    ctxs[0].display();
    for (int i = 1; i < count; i++) {
      translatee(sizes[i]);
      fill(128);
      noStroke();
      displayDivider();
      translatee(DIVIDER_THICKNESS);
      ctxs[i].display();
    }
    popMatrix();
  }
}

class HorizontalSplit extends SplitContextHandler {
  HorizontalSplit(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, int _count, Context[] _ctxs, int[] _sizes) {
    super(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, _count, _ctxs, _sizes);
  }
  int getSizee() {
    return WIDTH;
  }
  void resizee(Context ctx, int size) {
    ctx.resize(size, HEIGHT);
  }
  int minSizee(Context ctx) {
    return ctx.minWidth();
  }
  int getMouse() {
    return mouseX;
  }
  void setMouse(int val) {
    mouseX = val;
  }
  void translatee(int val) {
    translate(val, 0);
  }
  void displayDivider() {
    rect(0, 0, DIVIDER_THICKNESS, HEIGHT);
  }
}

HorizontalSplit HorizontalSplit(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, Context c1, float s1, Context c2, float s2) {
  int p1 = round((_WIDTH - _DIVIDER_THICKNESS) * s1 / (s1 + s2));
  int p2 = _WIDTH - _DIVIDER_THICKNESS - p1;
  return new HorizontalSplit(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, 2, new Context[] {c1, c2}, new int[] {p1, p2});
}

HorizontalSplit HorizontalSplit(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, Context c1, float s1, Context c2, float s2, Context c3, float s3) {
  int p1 = round((_WIDTH - 2 * _DIVIDER_THICKNESS) * s1 / (s1 + s2 + s3));
  int p2 = round((_WIDTH - 2 * _DIVIDER_THICKNESS) * s2 / (s1 + s2 + s3));
  int p3 = _WIDTH - 2 * _DIVIDER_THICKNESS - p1 - p2;
  return new HorizontalSplit(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, 3, new Context[] {c1, c2, c3}, new int[] {p1, p2, p3});
}

HorizontalSplit HorizontalSplitTest(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, int count) {
  int pixs = round(float(_WIDTH - (count - 1) * _DIVIDER_THICKNESS) / count);
  int[] sizes = new int[count];
  Context[] ctxs = new Context[count];
  for (int i = 0; i < count - 1; i++) sizes[i] = pixs;
  sizes[count - 1] = _WIDTH - (count - 1) * (pixs + _DIVIDER_THICKNESS);
  for (int i = 0; i < count; i++)ctxs[i] = new TestContext(width, height);
  return new HorizontalSplit(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, count, ctxs, sizes);
}

//class VerticalSplit extends SplitContextHandler {
//  VerticalSplit(int _WIDTH, int _HEIGHT) {
//    super(_WIDTH, _HEIGHT);
//  }
//  int getMouse() {
//    return mouseX;
//  }
//  void addMouse(int offset) {
//    mouseX += offset;
//  }
//}
