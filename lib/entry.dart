class Entry {
  Entry(this.title, this.level, this.id, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
  final int level;
  int id;
}