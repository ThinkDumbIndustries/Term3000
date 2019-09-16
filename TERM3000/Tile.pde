abstract class Tile {
  TFile img;
  boolean selected;
  boolean repaint = true;
  boolean visible;

  abstract void display(int x, int y, int w, int h);
}

class TextTile extends Tile {
  String text;
  color fill;
  color bg;

  TextTile(String _text) {
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

  ColorTile(color col) {
    this.col = col;
  }

  ColorTile() {
    this(color(color(0, random(255), 128+random(128))));
  }

  void display(int x, int y, int w, int h) {
    fill(col);
    noStroke();
    rect(0, 0, w, h);
  }
}
