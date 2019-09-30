/*
Tag relation is best described by a partial order. Given the Tag's are a set, they form a Partially Ordered Set, or POSET.
 To store 
 */

import java.util.BitSet;

TagManager tagmanager;


void setupTagManager_() {
  // load tag structure data from files
  tagmanager = new TagManager();
  Tag a = tagmanager.addTag("A");
  Tag b = tagmanager.addTag("B");
  Tag c = tagmanager.addTag("C");
  Tag d = tagmanager.addTag("D");
  tagmanager.makeASubtagOf(c.id, b.id);
  tagmanager.makeASubtagOf(b.id, a.id);
  tagmanager.makeASubtagOf(d.id, c.id);
  tagmanager.printt();
  tagmanager.save();
}

void setupTagManager() {
  tagmanager = new TagManager();
  tagmanager.load();
  tagmanager.printt();
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

  public void save() {
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
    } 
    catch (Exception e) {
      println("Could not load tags!!!");
      println(e);
    }
  }

  private void reduce() {
    println();
    println("   -----------   REDUCED REDUCED REDUCED   -----------   ");
    println();
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
    printt();
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
    tagmanager.expand();
  }

  void delete(Tag tag) {
    for (int i = tag.id + 1; i < alltags.size(); i++) alltags.get(i).id --;
    alltags.remove(tag);
  }

  public Tag addTag(String name) {
    Tag ntag = new Tag(alltags.size(), name);
    //ntag.parents.add(alltags.get(0));
    alltags.add(ntag);
    BitSet bs = new BitSet();
    //bs.set(0); //Every tag is a child of source
    reachable.add(bs);
    return ntag;
  }

  private void makeASubtagOf(int child, int parent) {
    if (isASubtagOf(child, parent)) return;
    //alltags.get(parent).children.add(alltags.get(child));
    //alltags.get(child).parents.add(alltags.get(parent));
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
        final float MIN = 0.8;
        final float MAX = 1.3;
        float f = 0;
        if (d < MIN) f = ((d - MIN) * ATTRCACTION) / d;
        else if (d > MAX) f = ((d - MAX) * ATTRCACTION) / d;
        t.apply(dx*f, dy*f);
        f *= -0.1;
        p.apply(dx*f, dy*f);
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

  Tag(int id, String name) {
    this.id = id;
    this.name = name;
    this.parents = new ArrayList<Tag>();
    this.children = new ArrayList<Tag>();
    this.x = random(-5, 5);
    this.y = random(-5, 5);
    this.sx = 0;
    this.sy = 0;
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
