class DateNavigatorContext extends HorizontalSplit {
  ListSelectContext datelist;

  DateNavigatorContext(int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT, 10, 2, 
      new Context[] {new ListSelectContext(10, 10, dates), new TestContext(10, 10)}, 
      new int[] {170, _WIDTH - 170 - 10}
      );
    datelist = (ListSelectContext)ctxs[0]; // I hate you java. Lemme do some stuff before I call my damn super constructor!!!
    selectDate(0);
  }

  void selectDate(int id) {
    lastSelectedId = id;
    ThumbableFile[] thumbablefiles = loadThumbableFiles(dates[datelist.selectedId].folderLocation());
    ctxs[1] = new TileGrid(128, 128, thumbablefiles);
    doResizeFlag[1] = true;
  }

  int lastSelectedId = -1;

  void display() {
    if (lastSelectedId != datelist.selectedId) selectDate(datelist.selectedId);
    super.display();
  }

  void flagEverythingForRepaint() {
    ctxs[1].flagEverythingForRepaint();
  }
}
