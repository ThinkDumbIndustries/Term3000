import processing.video.*;

class TMovie extends TThumbable {
  TMovie(String _location) {
    this.location = _location;
  }

  ThumbableTile makeTile(int id) {
    return new ThumbableTile(this, id);
  }

  MovieContext toContext(int _WIDTH, int _HEIGHT) {
    return new MovieContext(this, _WIDTH, _HEIGHT);
  }
}

class MovieContext extends Context {
  Movie mov;

  MovieContext(TMovie tmov, int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
    mov = new Movie(SKETCH, ROOT + "/" + tmov.location);
    mov.loop();
  }

  void deconstruct() {
    mov.stop();
  }

  boolean show_navbar = false;
  boolean navbar_dragged = true;

  void mousePressed() {
    if (!mousePressed) return;
    if (!show_navbar) return;
    navbar_dragged = true;
    mouseDragged();
  }

  void mouseReleased() {
    navbar_dragged = false;
  }

  void mouseDragged() {
    if (!navbar_dragged) return;
    float time = map(mouseX, 0, WIDTH, 0, mov.duration());
    time = constrain(time, 0, mov.duration());
    mov.jump(time);
  }

  void mouseMoved() {
    boolean _show_navbar = mouseY > HEIGHT - 64;
    if (show_navbar == _show_navbar) return;
    show_navbar = _show_navbar;
    reedraw();
  }

  void display() {
    fill(0);
    noStroke();
    rect(0, 0, WIDTH, HEIGHT);
    pushMatrix();
    translate(WIDTH*.5, HEIGHT*.5);
    float scale = min(float(WIDTH)/mov.width, float(HEIGHT)/mov.height);
    scale(scale);
    imageMode(CENTER);
    image(mov, 0, 0);
    popMatrix();
    if (show_navbar || navbar_dragged) {
      pushMatrix();
      translate(0, HEIGHT - 50);
      noStroke();
      fill(0, 128);
      rect(0, 0, WIDTH, 50);
      fill(255);
      float x = map(mov.time(), 0, mov.duration(), 0, WIDTH);
      rect(x -2, 0, 4, 50);
      popMatrix();
    }
  }

  boolean playing = true;

  void keyPressed() {
    if (key != ' ') return;
    if (playing) mov.pause();
    else mov.play();
    playing = !playing;
  }
}
