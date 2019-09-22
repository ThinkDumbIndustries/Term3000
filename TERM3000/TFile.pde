/*
G prefix for 'groupment of classes', notably:
 + abstract class TFile implements Contextable
 + class NoFile extends TFile
 */

import java.util.Arrays;

ThumbableFile[] loadThumbableFiles(String folderLocation) {
  File folder = new File(ROOT + "/" + folderLocation);
  println("Looking for files in: " + folder.getAbsolutePath());
  File[] children = folder.listFiles();
  ThumbableFile[] files = new ThumbableFile[children.length];
  int id = 0;
  for (int i = 0; i < children.length; i++) {
    String path = folderLocation + "/" + children[i].getName();
    TFile tf = createFile(path);
    if (ThumbableFile.class.isAssignableFrom(tf.getClass())) {
      files[id] = (ThumbableFile)tf;
      id++;
    }
  }
  return Arrays.copyOf(files, id);
}

// Factory for files
TFile createFile(String path) {
  String ext = path.substring(path.lastIndexOf('.')).toLowerCase();
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

  Context toContext(int _WIDTH, int _HEIGHT) {
    return new TestContext(_WIDTH, _HEIGHT); // Not ideal, best to have an error context maybe?
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
