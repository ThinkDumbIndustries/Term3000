class TileGrid {
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
    for (int i = 1; i < tiles.length; i++) tiles[i] = new ColorTile();
    tiles[0] = new ColorTile(color(255, 0, 0));
    tiles[tiles.length-1] = new ColorTile(color(255, 255, 0));
  }

  TileGrid(int GRID_WIDTH, int GRID_HEIGHT) {
    this(GRID_WIDTH, GRID_HEIGHT, 5);
  }

  void setTilesPerLine(int _TILES_PER_LINE, boolean force) {
    _TILES_PER_LINE = max(1, _TILES_PER_LINE);
    if (TILES_PER_LINE == _TILES_PER_LINE && !force) return;

    int OLD_TILES_PER_LINE = TILES_PER_LINE;
    this.TILES_PER_LINE = _TILES_PER_LINE;

    SCROLL_BAR_WIDTH = 10;

    TILE_WIDTH = (GRID_WIDTH - SCROLL_BAR_WIDTH) / TILES_PER_LINE;
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
    for (int j = 0; j < LINES_PER_SCREEN; j++) {
      for (int i = 0; i < TILES_PER_LINE; i++) {
        int id = (j + current_line) * TILES_PER_LINE + i;
        if (id >= tiles.length) break;
        tiles[id].visible = false;
      }
    }
    current_line = line;
    for (int i = 0; i < tiles.length; i++) tiles[i].repaint = true;
    for (int j = 0; j < LINES_PER_SCREEN; j++) {
      for (int i = 0; i < TILES_PER_LINE; i++) {
        int id = (j + current_line) * TILES_PER_LINE + i;
        if (id >= tiles.length) break;
        tiles[id].visible = true;
      }
    }
    bar.location = current_line;
    redraw();
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
