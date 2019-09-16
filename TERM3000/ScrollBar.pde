class ScrollBar {
  int location, max;

  int WIDTH, HEIGHT;
  float BAR_HEIGHT;// as percentage of HEIGHT

  ScrollBar(int location, int max, int WIDTH, int HEIGHT, float BAR_SIZE) {
    this.location = location;
    this.max = max;
    this.WIDTH = WIDTH;
    this.HEIGHT = HEIGHT;
    BAR_HEIGHT = constrain(BAR_SIZE * HEIGHT, 0, HEIGHT);
  }

  ScrollBar(int max, int WIDTH, int HEIGHT, float BAR_SIZE) {
    this(0, max, WIDTH, HEIGHT, BAR_SIZE);
  }

  void setLocation(int loc) {
    location = constrain(loc, 0, max);
  }

  void display() {
    float y;
    if (max == 0) y = 0;
    else y = map(location, 0, max, 0, HEIGHT - BAR_HEIGHT);
    rect(0, y, WIDTH, BAR_HEIGHT, WIDTH, WIDTH, WIDTH, WIDTH);
  }
}
