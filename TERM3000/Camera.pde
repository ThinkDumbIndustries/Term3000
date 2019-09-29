class Camera {
  float x = 0, y = 0;
  float zoom = 30;
  Camera() {
  }
  void apply(int WIDTH, int HEIGHT) {
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
}
