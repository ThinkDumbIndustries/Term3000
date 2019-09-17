TFile[] files;

void loadFiles() {
  File folder = new File(ROOT + "/2014/08-Aout");
  println("Looking for files in: " + folder.getAbsolutePath());
  File[] children = folder.listFiles();
  files = new TFile[children.length];
  for (int i = 0; i < children.length; i++) {
    String path = "2014/08-Aout/" + children[i].getName();
    files[i] = createFile(path);
  }
}

// Factory for files
TFile createFile(String path) {
  String ext = path.substring(path.indexOf('.')).toLowerCase();
  if (extIsImage(ext)) return new TImage(path);
  else if (extIsMovie(ext)) return new TMovie(path);
  return new NoFile(path);
}

boolean extIsImage(String ext) {
  return ext.equals(".jpg") || ext.equals(".jpeg") ||
    ext.equals(".tif") || ext.equals(".tiff") ||
    ext.equals(".png") ||
    ext.equals(".gif") ||
    ext.equals(".tga");
}

boolean extIsMovie(String ext) {
  return ext.equals(".mov");
}



abstract class TFile implements Contextable {
  String location;

  abstract Tile makeTile(int id);

  Context toContext(int _WIDTH, int _HEIGHT) {
    return new BlankContext(_WIDTH, _HEIGHT);
  }
}

class NoFile extends TFile {
  NoFile(String _location) {
    this.location = _location;
  }

  TextTile makeTile(int id) {
    TextTile tt = new TextTile(this, "Unsupported File:\n"+location);
    tt.setFill(color(240, 0, 0));
    return tt;
  }
}

abstract class TThumbable extends TFile {
  String getThumbnailAbsoluteLocation() {
    int indx = location.indexOf('.');
    return ROOT + "/thumbnails/" + location.substring(0, indx) + ".jpg";
    //return ROOT + "/thumbnailstif/" + location.substring(0, indx) + ".tif";
  }
}

class TImage extends TThumbable {
  TImage(String _location) {
    this.location = _location;
  }

  ThumbableTile makeTile(int id) {
    return new ThumbableTile(this, id);
  }
}

class TMovie extends TThumbable {
  TMovie(String _location) {
    this.location = _location;
  }

  ThumbableTile makeTile(int id) {
    return new ThumbableTile(this, id);
  }
}
