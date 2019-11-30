/*
G prefix for 'groupment of classes', notably:
 + class TImage extends TThumbable 
 + class ImageContext extends ConcreteContext
 */

class TImage extends ThumbableFile {
  TImage(String _location) {
    this.location = _location;
  }

  ThumbableTile makeTile(int id) {
    return new ThumbableTile(this, id);
  }

  ImageContext toContext(int _WIDTH, int _HEIGHT) {
    return new ImageContext(this, _WIDTH, _HEIGHT);
  }
  int getOrientation() {
    File file = new File(getAbsoluteLocation());
    String orientation_description = null;
    try {
      Metadata metadata = ImageMetadataReader.readMetadata(file);

      //println(metadata, "Using ImageMetadataReader");
      Directory directory = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
      if (directory != null) {
        for (Tag tag : directory.getTags()) {
          if ("Orientation".equals(tag.getTagName())) {
            orientation_description = tag.getDescription();
            break;
          }
        }
      }
    }
    catch (ImageProcessingException e) {
      println(e);
    } 
    catch (IOException e) {
      println(e);
    }
    if (orientation_description != null) {
      if (orientation_description.contains("90")) return 1;
      else if (orientation_description.contains("180")) return 2;
      else if (orientation_description.contains("270")) return 3;
    }
    return 0;
  }
}

class ImageContext extends ConcreteContext {
  PImage full;
  float scale;
  int orientation;

  ImageContext(TImage timage, int _WIDTH, int _HEIGHT) {
    super(_WIDTH, _HEIGHT);
    full = loadImage(ROOT + "/" + timage.location);
    orientation = timage.getOrientation();
    if (orientation % 2 == 0) scale = min(float(WIDTH)/full.width, float(HEIGHT)/full.height);
    else scale = min(float(WIDTH)/full.height, float(HEIGHT)/full.width);
  }

  void resize(int _WIDTH, int _HEIGHT) {
    super.resize(_WIDTH, _HEIGHT);
    if (orientation % 2 == 0) scale = min(float(WIDTH)/full.width, float(HEIGHT)/full.height);
    else scale = min(float(WIDTH)/full.height, float(HEIGHT)/full.width);
  }

  void display() {
    fill(0);
    noStroke();
    rect(0, 0, WIDTH, HEIGHT);
    pushMatrix();
    translate(WIDTH*.5, HEIGHT*.5);
    scale(scale);
    imageMode(CENTER);
    rotate(orientation*HALF_PI);
    image(full, 0, 0);
    popMatrix();
  }
}
