final int MIN_SCROLL_BAR_WIDTH = 10;

class TileGrid extends Context {
  int TILES_PER_LINE;
  int GRID_WIDTH, GRID_HEIGHT;

  int SCROLL_BAR_WIDTH;

  float IMAGE_RATIO = 3.0 / 4;
  int TILE_WIDTH, TILE_HEIGHT;

  int LINES_PER_SCREEN;

  int current_line = 0;
  int MAX_LINE;

  Tile[] tiles;

  ScrollBar bar;

  TileGrid(int _GRID_WIDTH, int _GRID_HEIGHT, int _TILES_PER_LINE) {
    //setupColorTiles();
    setupTiles(files);

    this.GRID_WIDTH = _GRID_WIDTH;
    this.GRID_HEIGHT = _GRID_HEIGHT;
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

  TileGrid(int GRID_WIDTH, int GRID_HEIGHT) {
    this(GRID_WIDTH, GRID_HEIGHT, 5);
  }

  void setTilesPerLine(int _TILES_PER_LINE, boolean force) {
    _TILES_PER_LINE = max(1, _TILES_PER_LINE);
    if (TILES_PER_LINE == _TILES_PER_LINE && !force) return;

    int OLD_TILES_PER_LINE = TILES_PER_LINE;
    this.TILES_PER_LINE = _TILES_PER_LINE;

    setOnscreenTilesVisibleTo(false);
    TILE_WIDTH = (GRID_WIDTH - MIN_SCROLL_BAR_WIDTH) / TILES_PER_LINE;
    SCROLL_BAR_WIDTH = GRID_WIDTH - TILE_WIDTH * TILES_PER_LINE;
    TILE_HEIGHT = int(TILE_WIDTH * IMAGE_RATIO);
    LINES_PER_SCREEN = 1 + (GRID_HEIGHT - 1) / TILE_HEIGHT;

    MAX_LINE = max(0, ((tiles.length - 1) / TILES_PER_LINE) - LINES_PER_SCREEN + 2);

    bar = new ScrollBar(MAX_LINE, SCROLL_BAR_WIDTH, GRID_HEIGHT, float(LINES_PER_SCREEN) / (1 + tiles.length / TILES_PER_LINE));

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
  }

  void keyPressed() {
    if (key == 'r') {
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

  void mousePressed() {
    if (!mousePressed) return;
    Tile t = getTileAtScreenPos(mouseX, mouseY);
    if (t == null) return;
    if (t.tfile == null) return; // if ColorTile or TextTile, no tfile exists
    println(t.tfile.location);
  }

  Tile getTileAtScreenPos(int x, int y) {
    if (x < 0 || y < 0 || x > GRID_WIDTH - SCROLL_BAR_WIDTH || y > GRID_HEIGHT) return null;
    int i = mouseX / TILE_WIDTH;
    int j = mouseY / TILE_HEIGHT;
    int id = TILES_PER_LINE * (j + current_line) + i;
    if (id >= tiles.length) return null;
    return tiles[id];
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
    translate(GRID_WIDTH - SCROLL_BAR_WIDTH, 0);
    noStroke();
    fill(255);
    bar.display();
    popMatrix();
  }
}
