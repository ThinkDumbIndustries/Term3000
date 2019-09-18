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
  }

  boolean playing = true;

  void keyPressed() {
    if (key != ' ') return;
    if (playing) mov.pause();
    else mov.play();
    playing = !playing;
  }
}
