import 'package:flutter/material.dart';
import 'entry.dart';
import 'search.dart';
import 'dart:convert';
import 'open_content.dart';
import 'screen_arguments.dart';
import 'content_search.dart';

final pageName = 'ALTERATIONS';
TextEditingController searchController = TextEditingController();

class Alteration extends StatefulWidget {
  static String get routeName => '/alterations';

  @override
  AlterationPage createState() => AlterationPage();
}

var contentData;
var sectionSearchList, chapterSearchList;
bool searchSection = false;
bool searchContent = true;

class AlterationPage extends State<Alteration> {
  List<dynamic> mainData = <dynamic>[];

  loadChapterJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/alteration_chapters.json');
  }

  loadContentJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/alteration_contents.json');
  }

  @override
  void initState() {
    this.loadChapterJson().then((var chapterJson) {
      this.loadContentJson().then((var contentJson) {
        var chapterData = json.decode(chapterJson);

        contentData = json.decode(contentJson);
        chapterSearchList = chapterData;

        // List<Entry> tempSections;

        for (var i = 1; i < chapterData.length; i++) {
          mainData.add(
              Entry(chapterData[i]['title'], level1, chapterData[i]['id']));
        }

        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchbar = Padding(
      padding: EdgeInsets.all(7.0),
      child: TextField(
        onSubmitted: (value) {
          SearchAlteration(value.trim(), context);
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.all(12.0),
        ),
        controller: searchController,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Alteration Acts'),
          backgroundColor: Colors.greenAccent[600],
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: <Widget>[
              searchbar,
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return EntryItem(mainData[index]);
                },
                itemCount: mainData == null ? 0 : mainData.length,
              ))
            ],
          ),
        ));
  }
}

String getHeader(int chapterId) {
  var tempStr = '$pageName\n';
  var chapter = getChapter(chapterId, chapterSearchList);
  if (chapter != '') tempStr += chapter['title'] + '\n';

  return tempStr;
}

const int level0 = 0;
const int level1 = 1;
const int level2 = 2;

class EntryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildTiles(Entry root) {
      if (root.children.isEmpty && root.level != level1)
        return ListTile(title: Text(root.title));
      if (root.children.isEmpty && root.level == level1)
        return ListTile(
          title: Text(root.title),
          onTap: () {
            Navigator.pushNamed(context, OpenContent.routeName,
                arguments: ScreenArguments(root.title,
                    getContent(root.id, contentData), getHeader(root.id)));
          },
        );
      return ExpansionTile(
        key: PageStorageKey<Entry>(root),
        title: Text(root.title),
        children: root.children.map(_buildTiles).toList(),
        trailing: Icon(Icons.arrow_drop_down_circle),
      );
    }

    return _buildTiles(entry);
  }

  const EntryItem(this.entry);

  final Entry entry;
}

class SearchAlteration {
  String txt;
  SearchAlteration(String txt, BuildContext context) {
    this.txt = txt;

    List<Widget> searchContent = [];

    void performsearch() async {
      for (var i = 0; i < contentData.length; i++) {
        if (contentData[i]['content']
            .toLowerCase()
            .contains(txt.toLowerCase())) {
          var chapter =
              getChapter(contentData[i]['section_id'], chapterSearchList);
          String content = contentData[i]['content'];

          searchContent.add(
              contentsearch(context, txt, content, chapter['title'], '', null));
          searchContent.add(SizedBox(
            height: 30.0,
          ));
        }
      }
    }

    performsearch();
    // print("array is : " + searchContent.toString());
    Navigator.pushNamed(context, SearchClass.routeName,
        arguments: SearchArgs(searchContent, txt));
  }

  //  SearchBar.sendSearchArgs();
}
