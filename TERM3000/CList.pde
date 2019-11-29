class ListSelectContext extends ConcreteContext {
  int BOX_HEIGHT;
  int BOX_MARGIN;
  int LINE_MARGIN;

  int SCROLL_BAR_WIDTH;

  int LINES_PER_SCREEN;
  int current_line = 0;
  int MAX_LINE;
  ScrollBar bar;

  Object[] boxes;
  int selectedId = 0;

  ListSelectContext(int _WIDTH, int _HEIGHT, Object[] _boxes, int _BOX_HEIGHT, int _BOX_MARGIN, int _LINE_MARGIN, int _SCROLL_BAR_WIDTH) {
    super(_WIDTH, _HEIGHT);
    if (_boxes.length <= 0) throw new IllegalArgumentException("boxes.length <= 0");
    this.boxes = _boxes;
    this.BOX_HEIGHT = _BOX_HEIGHT;
    this.BOX_MARGIN = _BOX_MARGIN;
    this.LINE_MARGIN = _LINE_MARGIN;
    this.SCROLL_BAR_WIDTH = _SCROLL_BAR_WIDTH; 
    setupScrollbar();
  }

  ListSelectContext(int _WIDTH, int _HEIGHT, Object[] boxes) {
    // Set LINE_MARGIN to -5, so that the space between boxes is not doubled by BOX_MARGIN
    this(_WIDTH, _HEIGHT, boxes, 50, 5, -5, MIN_SCROLL_BAR_WIDTH);
  }

  void setupScrollbar() {
    // Very much copy-pasted from TileGrid's 'setTilesPerLine()'
    int TILE_HEIGHT = BOX_HEIGHT + 2 * BOX_MARGIN + LINE_MARGIN;
    LINES_PER_SCREEN = 1 + (HEIGHT - 1 + LINE_MARGIN) / TILE_HEIGHT;

    MAX_LINE = max(0, (boxes.length - 1) - LINES_PER_SCREEN + 2);
    current_line = constrain(current_line, 0, MAX_LINE);
    bar = new ScrollBar(MAX_LINE, SCROLL_BAR_WIDTH, HEIGHT, float(LINES_PER_SCREEN) / (MAX_LINE + LINES_PER_SCREEN));
    setLine(current_line); // important for setting visible up
  }

  void setLine(int _current_line) {
    if (_current_line == current_line) return;
    current_line = constrain(_current_line, 0, MAX_LINE);
    bar.location = current_line;
    reedraw();
  }

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
    setupScrollbar();
  }

  void mouseWheel(MouseEvent event) {
    setLine(constrain(event.getCount(), -1, 1) + current_line);
    reedraw();
  }

  void keyPressed() {
    if (key == 'R') reedraw();
    else if (keyCode == UP) setLine(current_line - 1);
    else if (keyCode == DOWN)  setLine(current_line + 1);
    else if (keyCode == 34) setLine(current_line + LINES_PER_SCREEN - 1); // Page Up
    else if (keyCode == 33) setLine(current_line - LINES_PER_SCREEN + 1); // Page Down
    else if (keyCode == 36) setLine(0);             // Home
    else if (keyCode == 35) setLine(MAX_LINE); // End
  }

  boolean bar_dragged = false;

  void mousePressed() {
    if (!mousePressed) return;
    if (mouseX > WIDTH - bar.WIDTH) {
      if (mouseX > WIDTH - bar.WIDTH) {
        bar_dragged = true;
        mouseDragged();
      }
    } else {
      int indx = getTileIndxAtScreenPos(mouseX, mouseY);
      if (indx != -1 && indx != selectedId) {
        selectedId = indx;
        reedraw();
      }
    }
  }

  void mouseReleased() {
    bar_dragged = false;
  }

  void mouseDragged() {
    if (!bar_dragged) return;
    bar.setScreenLocation(mouseY);
    setLine(bar.location);
    reedraw();
  }

  int getTileIndxAtScreenPos(int x, int y) {
    int h = BOX_HEIGHT + 2 * BOX_MARGIN + LINE_MARGIN;
    int my = mouseY % h;
    if (x < BOX_MARGIN || my < BOX_MARGIN || x > WIDTH - bar.WIDTH - BOX_MARGIN || my > BOX_HEIGHT + BOX_MARGIN || y > HEIGHT) return -1;
    int j = mouseY / h;
    int id = j + current_line;
    if (id >= boxes.length) return -1;
    return id;
  }

  void display() {
    pushStyle();
    fill(0);
    noStroke();
    rect(0, 0, WIDTH, HEIGHT);
    pushMatrix();
    for (int i = 0; i < LINES_PER_SCREEN; i++) {
      int id = i + current_line;
      if (id >= boxes.length) break;
      if (id == selectedId) fill(200); 
      else fill(255);
      stroke(128);
      rect(BOX_MARGIN, BOX_MARGIN, WIDTH - 2 * BOX_MARGIN - SCROLL_BAR_WIDTH, BOX_HEIGHT);
      fill(0);
      textAlign(CENTER, CENTER);
      text(boxes[id].toString(), BOX_MARGIN, BOX_MARGIN, WIDTH - 2 * BOX_MARGIN - SCROLL_BAR_WIDTH, BOX_HEIGHT); 
      translate(0, BOX_HEIGHT + 2 * BOX_MARGIN + LINE_MARGIN);
    }
    popMatrix();
    pushMatrix();
    translate(WIDTH - bar.WIDTH, 0);
    noStroke();
    fill(255);
    bar.display();
    popMatrix();
    popStyle();
  }
}
