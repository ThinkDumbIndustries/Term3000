abstract class SplitContextHandler extends ConcreteContext {
  static final int
    FOCUS_ON_HOVER = 0, 
    FOCUS_ON_CLICK = 1; // Not totally fleshed out yet, although this is a good start for futur expansion
  int focusMode = FOCUS_ON_HOVER;
  int focusedId = 0;
  int hoveredId = -1;

  int DIVIDER_THICKNESS;
  int dividerId = -1;
  boolean dividerPressed = false; // DTI: dividerPressed => dividerId € [0..count)

  int count; // number of contexts
  Context[] ctxs;
  int[] sizes;
  int[] poses; // of dividers
  int[] minposes;
  int[] maxposes;

  SplitContextHandler(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, int _count, Context[] _ctxs, int[] _sizes) {
    super(_WIDTH, _HEIGHT);
    this.DIVIDER_THICKNESS = _DIVIDER_THICKNESS;
    this.count = _count;
    this.ctxs = _ctxs;
    this.sizes = _sizes;
    if (ctxs.length != count) throw new IllegalArgumentException("ctxs.length != count");
    if (sizes.length != count) throw new IllegalArgumentException("sizes.length != count");
    poses = new int[count + 1];
    minposes = new int[count + 1];
    maxposes = new int[count + 1];
    int total = - DIVIDER_THICKNESS;
    int mintotal = -DIVIDER_THICKNESS;
    for (int i = 0; i < count; i++) {
      if (sizes[i] < minSizee(ctxs[i])) throw new IllegalArgumentException("sizes[i] < getSizee(ctxs[i])");
      poses[i] = total;
      minposes[i] = mintotal;
      resizee(i);
      total += sizes[i] + DIVIDER_THICKNESS;
      mintotal += minSizee(ctxs[i]) + DIVIDER_THICKNESS;
    }
    int maxtotal = getSizee();
    maxposes[count] = maxtotal;
    for (int i = count - 1; i >= 0; i--) {
      maxtotal -= minSizee(ctxs[i]) + DIVIDER_THICKNESS;
      maxposes[i] = maxtotal;
    }
    poses[count] = total;
    if (total != getSizee()) throw new IllegalArgumentException("sizes does not sum up to WIDTH");
  }

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
    for (int i = 0; i < count; i++) resizee(i);
  }

  void setFocusMode(int mode) {
    this.focusMode = mode;
  }

  abstract int getSizee();
  abstract void resizee(int id);
  abstract int minSizee(Context ctx);
  abstract int getMouse(); // what luck that mouseX and mouseY are global and mutable!
  abstract void setMouse(int val);
  abstract void translatee(int pos);
  abstract void displayDivider();


  void dividerMoved() { // dividerPressed == true, mouseDragged:
    boolean[] doResize = new boolean[count]; 
    poses[dividerId] = constrain(getMouse() - DIVIDER_THICKNESS / 2, minposes[dividerId], maxposes[dividerId]);
    sizes[dividerId - 1] = poses[dividerId] - poses[dividerId - 1] - DIVIDER_THICKNESS;
    sizes[dividerId] = poses[dividerId + 1] - poses[dividerId] - DIVIDER_THICKNESS;
    doResize[dividerId - 1] = true;
    doResize[dividerId] = true;
    // ripple changes if necessary
    for (int i = dividerId - 1; i > 0; i--) {
      if (sizes[i] >= minSizee(ctxs[i])) break;
      poses[i] = poses[i + 1] - minSizee(ctxs[i]) - DIVIDER_THICKNESS;
      sizes[i] = minSizee(ctxs[i]);
      sizes[i - 1] = poses[i] - poses[i - 1] - DIVIDER_THICKNESS;
      doResize[i] = true;
      doResize[i - 1] = true;
    }
    for (int i = dividerId; i < count - 1; i++) { // -1
      if (sizes[i] >= minSizee(ctxs[i])) break;
      poses[i + 1] = poses[i] + minSizee(ctxs[i]) + DIVIDER_THICKNESS;
      sizes[i] = minSizee(ctxs[i]);
      sizes[i + 1] = poses[i + 2] - poses[i + 1] - DIVIDER_THICKNESS;
      doResize[i] = true;
      doResize[i + 1] = true;
    }
    for (int i = 0; i < count; i++) if (doResize[i]) resizee(i);
    reedraw();
  }


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
      } else if (getMouse() < sizes[i] + DIVIDER_THICKNESS) dividerId = i + 1; 
      else {
        addMouse( - sizes[i] - DIVIDER_THICKNESS); 
        continue;
      }
      break;
    }
    setMouse(temp);
  }
  void mouseDragged() {
    if (dividerPressed) dividerMoved(); 
    else ctxs[focusedId].mouseDragged();
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
      translatee(sizes[i - 1]);
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
  void resizee(int id) {
    ctxs[id].resize(sizes[id], HEIGHT);
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

class VerticalSplit extends SplitContextHandler {
  VerticalSplit(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, int _count, Context[] _ctxs, int[] _sizes) {
    super(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, _count, _ctxs, _sizes);
  }
  int getSizee() {
    return HEIGHT;
  }
  void resizee(int id) {
    ctxs[id].resize(WIDTH, sizes[id]);
  }
  int minSizee(Context ctx) {
    return ctx.minHeight();
  }
  int getMouse() {
    return mouseY;
  }
  void setMouse(int val) {
    mouseY = val;
  }
  void translatee(int val) {
    translate(0, val);
  }
  void displayDivider() {
    rect(0, 0, WIDTH, DIVIDER_THICKNESS);
  }
}

VerticalSplit VerticalSplit(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, Context c1, float s1, Context c2, float s2) {
  int p1 = round((_HEIGHT - _DIVIDER_THICKNESS) * s1 / (s1 + s2)); 
  int p2 = _HEIGHT - _DIVIDER_THICKNESS - p1; 
  return new VerticalSplit(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, 2, new Context[] {c1, c2}, new int[] {p1, p2});
}

VerticalSplit VerticalSplit(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, Context c1, float s1, Context c2, float s2, Context c3, float s3) {
  int p1 = round((_HEIGHT - 2 * _DIVIDER_THICKNESS) * s1 / (s1 + s2 + s3)); 
  int p2 = round((_HEIGHT - 2 * _DIVIDER_THICKNESS) * s2 / (s1 + s2 + s3)); 
  int p3 = _HEIGHT - 2 * _DIVIDER_THICKNESS - p1 - p2; 
  return new VerticalSplit(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, 3, new Context[] {c1, c2, c3}, new int[] {p1, p2, p3});
}

VerticalSplit VerticalSplitTest(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, int count) {
  int pixs = round(float(_HEIGHT - (count - 1) * _DIVIDER_THICKNESS) / count); 
  int[] sizes = new int[count]; 
  Context[] ctxs = new Context[count]; 
  for (int i = 0; i < count - 1; i++) sizes[i] = pixs; 
  sizes[count - 1] = _HEIGHT - (count - 1) * (pixs + _DIVIDER_THICKNESS); 
  for (int i = 0; i < count; i++)ctxs[i] = new TestContext(width, height); 
  return new VerticalSplit(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, count, ctxs, sizes);
}

HorizontalSplit GridSplitTest(int _WIDTH, int _HEIGHT, int _DIVIDER_THICKNESS, int w, int h) {
  int pixs = round(float(_WIDTH - (w - 1) * _DIVIDER_THICKNESS) / w); 
  int[] sizes = new int[w]; 
  Context[] ctxs = new Context[w]; 
  for (int i = 0; i < w - 1; i++) sizes[i] = pixs; 
  sizes[w - 1] = _WIDTH - (w - 1) * (pixs + _DIVIDER_THICKNESS); 
  for (int i = 0; i < w; i++)ctxs[i] = VerticalSplitTest(width, height, _DIVIDER_THICKNESS, h); 
  return new HorizontalSplit(_WIDTH, _HEIGHT, _DIVIDER_THICKNESS, w, ctxs, sizes);
}
