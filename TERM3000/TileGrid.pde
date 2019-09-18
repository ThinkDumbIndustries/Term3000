final int MIN_SCROLL_BAR_WIDTH = 10;

class TileGrid extends ConcreteContext {
  final float IMAGE_RATIO = 3.0 / 4;
  int TILE_WIDTH, TILE_HEIGHT;
  int TILES_PER_LINE;

  int LINES_PER_SCREEN;
  int current_line = 0;
  int MAX_LINE;
  ScrollBar bar;

  Tile[] tiles;

  TileGrid(int _WIDTH, int _HEIGHT, int _TILES_PER_LINE) {
    super(_WIDTH, _HEIGHT);
    //setupColorTiles();
    setupTiles(files);
    setTilesPerLine(_TILES_PER_LINE, true);
  }

  void setupTiles(TFile[] files) {
    tiles = new Tile[files.length];
    for (int i = 0; i < files.length; i++) {
      tiles[i] = files[i].makeTile(i);
    }
  }

  void setupColorTiles() {
    tiles = new Tile[234];
    for (int i = 1; i < tiles.length; i++) tiles[i] = new ColorTile(null);
    tiles[0] = new ColorTile(null, color(255, 0, 0));
    tiles[tiles.length-1] = new ColorTile(null, color(255, 255, 0));
  }

  TileGrid(int _WIDTH, int _HEIGHT) {
    this(_WIDTH, _HEIGHT, 5);
  }

  void resize(int _WIDTH, int _HEIGHT) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
    setTilesPerLine(TILES_PER_LINE, true);
  }

  void setTilesPerLine(int _TILES_PER_LINE, boolean force) {
    _TILES_PER_LINE = max(1, _TILES_PER_LINE);
    if (TILES_PER_LINE == _TILES_PER_LINE && !force) return;

    int OLD_TILES_PER_LINE = TILES_PER_LINE;
    this.TILES_PER_LINE = _TILES_PER_LINE;

    setOnscreenTilesVisibleTo(false);
    TILE_WIDTH = (WIDTH - MIN_SCROLL_BAR_WIDTH) / TILES_PER_LINE;
    int SCROLL_BAR_WIDTH = WIDTH - TILE_WIDTH * TILES_PER_LINE;
    TILE_HEIGHT = int(TILE_WIDTH * IMAGE_RATIO);
    LINES_PER_SCREEN = 1 + (HEIGHT - 1) / TILE_HEIGHT;

    MAX_LINE = max(0, ((tiles.length - 1) / TILES_PER_LINE) - LINES_PER_SCREEN + 2);
    bar = new ScrollBar(MAX_LINE, SCROLL_BAR_WIDTH, HEIGHT, float(LINES_PER_SCREEN) / (MAX_LINE + LINES_PER_SCREEN));

    setLine(floor(float(current_line * OLD_TILES_PER_LINE) / TILES_PER_LINE), true); // important for setting visible up
  }

  void setLine(int line, boolean force) {
    line = constrain(line, 0, MAX_LINE);
    if (line == current_line && !force) return;
    repaint_background = true;
    setOnscreenTilesVisibleTo(false);
    current_line = line;
    setOnscreenTilesVisibleTo(true);
    for (int i = 0; i < tiles.length; i++) tiles[i].repaint = true;
    bar.location = current_line;
    reedraw();
  }

  void setOnscreenTilesVisibleTo(boolean visible_state) {
    for (int j = 0; j < LINES_PER_SCREEN; j++) {
      for (int i = 0; i < TILES_PER_LINE; i++) {
        int id = (j + current_line) * TILES_PER_LINE + i;
        if (id >= tiles.length) break;
        tiles[id].visible = visible_state;
      }
    }
  }

  void mouseWheel(MouseEvent event) {
    setLine(constrain(event.getCount(), -1, 1) + current_line, false);
    reedraw();
  }

  void keyPressed() {
    if (key == 'R') {
      for (int i = 0; i < tiles.length; i++) tiles[i].repaint = true;
      repaint_background = true;
      reedraw();
    } else if (keyCode == UP) setLine(current_line - 1, false);
    else if (keyCode == DOWN)  setLine(current_line + 1, false);
    else if (key == '+') setTilesPerLine(TILES_PER_LINE - 1, false);
    else if (key == '-') setTilesPerLine(TILES_PER_LINE + 1, false);
    else if (keyCode == 34) setLine(current_line + LINES_PER_SCREEN - 1, false); // Page Up
    else if (keyCode == 33) setLine(current_line - LINES_PER_SCREEN + 1, false); // Page Down
    else if (keyCode == 36) setLine(0, false);             // Home
    else if (keyCode == 35) setLine(MAX_LINE, false); // End
  }

  boolean bar_dragged = false;

  void mousePressed() {
    if (!mousePressed) return;
    int indx = getTileIndxAtScreenPos(mouseX, mouseY);
    if (indx == -1) {
      if (mouseX > WIDTH - bar.WIDTH) {
        bar_dragged = true;
        mouseDragged();
      }
    } else {
      Tile t = tiles[indx];
      if (t.tfile == null) return; // if ColorTile or TextTile, no tfile exists
      pushContext(new FullView(WIDTH, HEIGHT, files, indx));
    }
  }

  void mouseReleased() {
    bar_dragged = false;
  }

  void mouseDragged() {
    bar.setScreenLocation(mouseY);
    setLine(bar.location, false);
    reedraw();
  }

  int getTileIndxAtScreenPos(int x, int y) {
    if (x < 0 || y < 0 || x > WIDTH - bar.WIDTH || y > HEIGHT) return -1;
    int i = mouseX / TILE_WIDTH;
    int j = mouseY / TILE_HEIGHT;
    int id = TILES_PER_LINE * (j + current_line) + i;
    if (id >= tiles.length) return -1;
    return id;
  }

  void flagEverythingForRepaint() {
    for (int i = 0; i< tiles.length; i++) tiles[i].repaint = true;
    //for (int j = 0; j < LINES_PER_SCREEN; j++) {
    //  for (int i = 0; i < TILES_PER_LINE; i++) {
    //    int id = (j + current_line) * TILES_PER_LINE + i;
    //    if (id >= tiles.length) break;
    //    tiles[id].repaint = true;
    //  }
    //}
  }

  void display() {
    pushMatrix();
    for (int j = 0; j < LINES_PER_SCREEN; j++) {
      pushMatrix();
      for (int i = 0; i < TILES_PER_LINE; i++) {
        int id = (j + current_line) * TILES_PER_LINE + i;
        if (id >= tiles.length) break;
        tiles[id].display(0, 0, TILE_WIDTH, TILE_HEIGHT);
        translate(TILE_WIDTH, 0);
      }
      popMatrix();
      translate(0, TILE_HEIGHT);
    }
    popMatrix();
    pushMatrix();
    translate(WIDTH - bar.WIDTH, 0);
    noStroke();
    fill(255);
    bar.display();
    popMatrix();
  }
}
