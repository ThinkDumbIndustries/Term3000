interface Tilable {
  Tile makeTile(int id);
}

abstract class Tile {
  TFile tfile;
  boolean selected;
  boolean repaint = true;
  boolean visible;

  Tile(TFile _tfile) {
    this.tfile = _tfile;
  }

  abstract void display(int x, int y, int w, int h);
}

class TextTile extends Tile {
  String text;
  color fill;
  color bg;

  TextTile(TFile _tfile, String _text) {
    super(_tfile);
    this.text = _text;
    fill = color(255);
    bg = color(0);
  }

  void setFill(color _fill) {
    fill = _fill;
  }

  void setBg(color _bg) {
    this.bg = _bg;
  }

  void display(int x, int y, int w, int h) {
    pushStyle();
    noStroke();
    fill(bg);
    rect(0, 0, w, h);

    fill(fill);
    textAlign(CENTER, CENTER);
    text(text, 0, 0, w, h);
    popStyle();
  }
}

class ColorTile extends Tile {
  color col;

  ColorTile(TFile _tfile, color col) {
    super(_tfile);
    this.col = col;
  }

  ColorTile(TFile _tfile) {
    this(_tfile, color(color(0, random(255), 128+random(128))));
  }

  void display(int x, int y, int w, int h) {
    fill(col);
    noStroke();
    rect(0, 0, w, h);
  }
}
