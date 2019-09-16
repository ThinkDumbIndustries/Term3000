TImage[] images;

void loadImages() {
  File folder = new File(ROOT + "/2014/08-Aout");
  File[] children = folder.listFiles();
  images = new TImage[children.length];
  for (int i = 0; i < children.length; i++) {
    String path = "2014/08-Aout/" + children[i].getName();
    images[i] = new TImage(path);
  }
}

abstract class TFile {
  String location;
}

class TImage extends TFile {
  TImage(String _location) {
    this.location = _location;
  }

  String getThumbnailAbsoluteLocation() {
    int indx = location.indexOf('.');
    return ROOT + "/thumbnails/" + location.substring(0, indx) + ".jpg";
    //return ROOT + "/thumbnailstif/" + location.substring(0, indx) + ".tif";
  }
}
