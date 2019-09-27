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
      out.print(alltags.get(i).name);
      for (Tag parent : alltags.get(i).parents) out.print("," + parent.id);
      out.println();
    }    
    out.flush();
    out.close();
    exit();
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
        for (int c = 1; c < split.length; c++) {
          int parentId = int(split[c]);
          makeASubtagOf(i, parentId);
          alltags.get(i).parents.add(alltags.get(parentId));
          alltags.get(parentId).children.add(alltags.get(i));
        }
      }
    } 
    catch (Exception e) {
      println("Could not load tags!!!");
      println(e);
    }
  }

  private void reduce() {
    for (Tag t : alltags) {
      t.parents = new ArrayList<Tag>();
      t.children = new ArrayList<Tag>();
    }
    for (int i = 0; i < alltags.size(); i++) {
      for (int j = 0; j < alltags.size(); j++) {
        if (i == j) break;
        if (!isASubtagOf(i, j)) break;
        boolean isPrimitive = true;
        for (int k = 0; k < alltags.size(); k++) {
          if (k != i && k!= j && isASubtagOf(i, k) && isASubtagOf(k, j)) {
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
  }

  public Tag addTag(String name) {
    Tag ntag = new Tag(alltags.size(), name);
    ntag.parents.add(alltags.get(0));
    alltags.add(ntag);
    BitSet bs = new BitSet();
    bs.set(0); //Every tag is a child of source
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
    for (int i = 0; i < alltags.size(); i++) {
      for (int j = 0; j < alltags.size(); j++) {
        if (isASubtagOf(i, j)) print(" X");
        else print(" O");
      }
      println();
    }
    println();
  }
}

class Tag {
  int id;
  String name;
  ArrayList<Tag> parents;
  ArrayList<Tag> children;

  Tag(int id, String name) {
    this.id = id;
    this.name = name;
    this.parents = new ArrayList<Tag>();
    this.children = new ArrayList<Tag>();
  }
}
