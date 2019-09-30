/*
Tag relation is best described by a partial order. Given the Tag's are a set, they form a Partially Ordered Set, or POSET.
 To store 
 */

import java.util.BitSet;

TagManager tagmanager;

void setupTagManager() {
  tagmanager = new TagManager();
  tagmanager.load();
  //tagmanager.printt();
  //tagmanager.save();
}

class TagManager {
  ArrayList<Tag> alltags; // every tag has a unique ID
  ArrayList<BitSet> reachable; // stores the reachability relation
  // X is a subtag of Y

  TagManager() {
    alltags = new ArrayList<Tag>(1);
    alltags.add(new Tag(0, "Tous"));
    reachable = new ArrayList<BitSet>(1);
    reachable.add(new BitSet());
  }

  boolean DTI() {
    // Check for soundness of the data

    // the i th tag should have id = i
    for (int i = 0; i < alltags.size(); i++) if (alltags.get(i).id != i) {
      println("TM: DTI failure; alltags.get("+i+").id = "+alltags.get(i).id+" != "+i);
      return false;
    }

    // The POSET should be a POSET; notably:
    // - Transitive
    // - Reflexive
    // - Antisymmetric

    return true;
  }

  public void save() {
    println("TM: Saving...");
    if (!DTI()) return;
    reduce(); //if DTI is respected, should not be necessary
    PrintWriter out = createWriter(ROOT + "/tags.csv");
    out.println(alltags.size());
    for (int i = 0; i < alltags.size(); i++) {
      Tag tag = alltags.get(i);
      out.print(tag.name + "," + tag.x + "," + tag.y);
      for (Tag parent : tag.parents) out.print("," + parent.id);
      out.println();
    }    
    out.flush();
    out.close();
    println("TM: Saved!");
  }

  public void load() {
    BufferedReader in = createReader(ROOT + "/tags.csv");
    try {
      int tags = int(in.readLine());
      alltags = new ArrayList<Tag>(tags);
      reachable = new ArrayList<BitSet>(tags);
      for (int i = 0; i < tags; i++) {
        alltags.add(new Tag(i, ""));
        reachable.add(new BitSet());
      }
      for (int i = 0; i < tags; i++) {
        Tag tag = alltags.get(i);
        String[] split = split(in.readLine(), ',');
        tag.name = split[0];
        tag.x = float(split[1]);
        tag.y = float(split[2]);
        for (int c = 3; c < split.length; c++) {
          int parentId = int(split[c]);
          Tag parent = alltags.get(parentId);
          makeASubtagOf(i, parentId);
          tag.parents.add(parent);
          parent.children.add(tag);
        }
      }
      computeSize();
    } 
    catch (Exception e) {
      println("Could not load tags!!!");
      println(e);
    }
  }

  void computeSize() {
    for (Tag t : alltags) t.sizeFlag = false;
    for (Tag t : alltags) t.computeSize();
  }

  private void reduce() {
    for (Tag t : alltags) {
      t.parents = new ArrayList<Tag>();
      t.children = new ArrayList<Tag>();
    }
    for (int i = 0; i < alltags.size(); i++) {
      for (int j = 0; j < alltags.size(); j++) {
        if (i == j) continue;
        if (!isASubtagOf(i, j)) continue;
        boolean isPrimitive = true;
        for (int k = 0; k < alltags.size(); k++) {
          if (k != i && k != j && isASubtagOf(i, k) && isASubtagOf(k, j)) {
            isPrimitive = false;
            break;
          }
        }
        if (isPrimitive) {
          alltags.get(i).parents.add(alltags.get(j));
          alltags.get(j).children.add(alltags.get(i));
        }
      }
    }
  }

  private void expand() {
    reachable = new ArrayList<BitSet>(alltags.size());
    for (int i = 0; i < alltags.size(); i++) reachable.add(new BitSet());
    for (Tag t : alltags) for (Tag p : t.parents) makeASubtagOf(t.id, p.id);
  }

  public boolean isLonely(Tag t) {
    return t.children.size() != 0 || t.parents.size() != 0;
  }

  void makeLonely(Tag tag) {
    for (Tag t : tag.parents) t.children.remove(tag);
    for (Tag t : tag.children) t.parents.remove(tag);
    tag.children = new ArrayList<Tag>();
    tag.parents = new ArrayList<Tag>();
    expand();
    computeSize();
  }

  void delete(Tag tag) {
    for (int i = tag.id + 1; i < alltags.size(); i++) alltags.get(i).id --;
    alltags.remove(tag);
  }

  public Tag addTag(String name) {
    Tag ntag = new Tag(alltags.size(), name);
    alltags.add(ntag);
    BitSet bs = new BitSet();
    reachable.add(bs);
    return ntag;
  }

  private void makeASubtagOf(int child, int parent) {
    if (isASubtagOf(child, parent)) return;
    for (int i = 0; i < alltags.size(); i++) { 
      BitSet bs = reachable.get(i);
      if (isASubtagOf(i, child)) {
        bs.or(reachable.get(parent));
        bs.set(parent);
      }
    }
  }

  private boolean isASubtagOf(int child, int parent) {
    if (child == parent) return true;
    return reachable.get(child).get(parent);
  }

  public void printt() {
    for (Tag t : alltags) {
      println(t.id + " , " + t.name);
      for (Tag p : t.parents) println("   " + p.id + " , " + p.name);
    }
    for (int i = 0; i < alltags.size(); i++) {
      for (int j = 0; j < alltags.size(); j++) {
        if (isASubtagOf(i, j)) print(" X");
        else print(" O");
      }
      println();
    }
    println();
    println(alltags.size());
    for (int i = 0; i < alltags.size(); i++) {
      Tag tag = alltags.get(i);
      print(tag.name + "," + tag.x + "," + tag.y);
      for (Tag parent : tag.parents) print("," + parent.id);
      println();
    }
  }
  void update() {
    for (Tag t : alltags) {
      for (Tag p : t.parents) {
        float dx = p.x - t.x;
        float dy = p.y - t.y;
        float d = sqrt(dx*dx + dy*dy);
        float sr = t.r + p.r;
        final float MIN = sr + 0.2;
        final float MAX = sr + 1.3;
        float f = 0;
        if (d < MIN) f = ((d - MIN) * ATTRCACTION) / d;
        else if (d > MAX) f = ((d - MAX) * ATTRCACTION) / d;
        float fact = float(p.size)/t.size;
        t.apply(dx*f*fact, dy*f*fact);
        f *= -0.1;
        p.apply(dx*f/fact, dy*f/fact);
      }
    }
    for (Tag t : alltags)t.update();
  }
  boolean needsReedraw() {
    return true;
  }
}

final float FRICTION = 0.9;
final float ATTRCACTION = 0.01;

class Tag {
  int id;
  String name;
  ArrayList<Tag> parents;
  ArrayList<Tag> children;
  float x, y;
  float sx, sy;
  float totalForce;
  int size;
  boolean sizeFlag = false;
  float r;

  Tag(int id, String name) {
    this.id = id;
    this.name = name;
    this.parents = new ArrayList<Tag>();
    this.children = new ArrayList<Tag>();
    this.x = random(-5, 5);
    this.y = random(-5, 5);
    this.sx = 0;
    this.sy = 0;
    computeSize();
  }
  float computeSize() {
    if (sizeFlag) return size;
    else {
      size = 1;
      for (Tag c : children) size += c.computeSize();
      sizeFlag = true;
      r = 0.15 * sqrt(size);
      return size;
    }
  }
  boolean isA(Tag parent) {
    return tagmanager.isASubtagOf(id, parent.id);
  }
  void addParent(Tag p) {
    tagmanager.makeASubtagOf(id, p.id);
    tagmanager.reduce();
    tagmanager.computeSize();
  }
  void update() {
    sx *= FRICTION;
    sy *= FRICTION;
    x += sx;
    y += sy;
  }
  void apply(float ax, float ay) {
    sx += ax;
    sy += ay;
    totalForce += ax*ax + ay*ay;
  }
}
