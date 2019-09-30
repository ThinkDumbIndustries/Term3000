class Camera {
  int WIDTH, HEIGHT;
  float x = 0, y = 0;
  float zoom = 30;
  Camera(int _WIDTH, int _HEIGHT) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
  }
  Camera(int _WIDTH, int _HEIGHT, Camera old) {
    this.WIDTH = _WIDTH;
    this.HEIGHT = _HEIGHT;
    x = old.x;
    y = old.y;
    zoom = old.zoom;
  }
  void apply() {
    translate(WIDTH * .5, HEIGHT* .5);
    scale(zoom);
    translate(x, y);
  }
  void mouseDragged() {
    x += (mouseX - pmouseX) / zoom;
    y += (mouseY - pmouseY) / zoom;
  }
  void mouseWheel(MouseEvent event) {
    zoom *= pow(0.9, event.getCount());
  }
  float mx, my;
  void updateMouse() {
    mx = -x + (mouseX - WIDTH * .5) / zoom;
    my = -y + (mouseY - HEIGHT * .5) / zoom;
  }
}
