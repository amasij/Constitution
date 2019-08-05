import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'open_content.dart';
import 'screen_arguments.dart';
import 'cfrn.dart';
import 'search.dart';
import 'content_search.dart';
import 'cfrn_schedule.dart';
import 'acja_schedule.dart';
import 'entry.dart';
import 'bookmarks.dart';
import 'about.dart';
import 'alteration.dart';

final pageName='ACJA';
TextEditingController searchController = TextEditingController();

class Acja extends StatefulWidget {
  @override
  AcjaState createState() => AcjaState();
}

var contentData;
var sectionSearchList, chapterSearchList;
bool searchSection = true;
bool searchContent = false;

class AcjaState extends State<Acja> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  updateKeepAlive();

  List<dynamic> mainData = <dynamic>[];

  loadChapterJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/acja_chapters.json');
  }

  loadSectionJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/acja_sections.json');
  }

  loadContentJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/acja_contents.json');
  }

  @override
  void initState() {
    this.loadChapterJson().then((var chapterJson) {
      this.loadSectionJson().then((var sectionJson) {
        this.loadContentJson().then((var contentJson) {
          var chapterData = json.decode(chapterJson);
          var sectionData = json.decode(sectionJson);
          contentData = json.decode(contentJson);
          chapterSearchList = chapterData;
          sectionSearchList = sectionData;

          List<Entry> tempSections;

          for (var i = 1; i < chapterData.length; i++) {
            tempSections = <Entry>[];

            for (var j = 1; j < sectionData.length; j++) {
              if (sectionData[j]['chapter_id'] == chapterData[i]['id'])
                tempSections.add(Entry(sectionData[j]['title'], level1,
                    sectionData[j]['id'], <Entry>[]));
            }
            mainData.add(Entry(chapterData[i]['title'], level0,
                chapterData[i]['id'], tempSections));
          }
          mainData.add(ListTile(
            title: Text('Schedules'),
            onTap: () {
              Navigator.pushNamed(context, AcjaSchedule.routeName);
              //  Navigator.pushNamed(context, '/CfrnSchedule');
            },
          ));
          setState(() {});
        });
      });
    });
  }

  Widget _simplePopup() => PopupMenuButton<int>(
        icon: Icon(Icons.menu),
        itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 1,
                child: Text("Search By Sections"),
                checked: searchSection,
              ),
              PopupMenuDivider(
                height: 20,
              ),
              CheckedPopupMenuItem(
                value: 2,
                child: Text("Search By Contents"),
                checked: searchContent,
              ),
            ],
        onSelected: (value) {
          if (value == 1) {
            searchSection = true;
            searchContent = false;
          } else {
            searchContent = true;
            searchSection = false;
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final searchbar = Padding(
      padding: EdgeInsets.all(7.0),
      child: TextField(
        onSubmitted: (value) {
          SearchAcja(value.trim(), context);
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

    super.build(context);
    return Scaffold(
        body: SafeArea(
      top: true,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[Expanded(child: searchbar), _simplePopup()],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              if (index == mainData.length - 1) {
                return mainData[index];
              }
              return EntryItem(mainData[index]);
            },
            itemCount: mainData == null ? 0 : mainData.length,
          ))
        ],
      ),
    ));
  }
} // One entry in the multilevel list displayed by this app.

//
String getHeader(int sectionId)
{
  var section=getSection(sectionId,sectionSearchList);
  var tempStr='$pageName\n';
  var chapter=getChapter(section['chapter_id'], chapterSearchList);
  if(chapter!='')tempStr+=chapter['title']+'\n';
   tempStr+=section['title'];
  
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
                arguments: ScreenArguments(
                    root.title, getContent(root.id, contentData),getHeader(root.id)));
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


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "CFRN",
                  ),
                  Tab(
                    text: "ACJA",
                  )
                ],
              ),
              title: Text("CFRN 1999 and ACJA"),
            ),
            body: TabBarView(children: <Widget>[Cfrn(), Acja()]),
            drawer: Drawer(
                child: ListView(
              children: <Widget>[
             
                ListTile(
                  title: Text('Bookmarks'),
                  leading: Icon(Icons.book),
                  onTap: (){
                     Navigator.pushNamed(context, Bookmark.routeName);
                  } ,
                ),
                ListTile(
                  title: Text('About App'),
                  leading: Icon(Icons.info),
                  onTap: (){
                     Navigator.pushNamed(context, About.routeName);
                  }
                )
              ],
            ))));
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      primaryColor: Colors.greenAccent[600],
      accentColor: Colors.greenAccent[400],
      indicatorColor: Colors.green[700],

      // Define the default font family.
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      ),
    ),
    routes: {
      '/': (context) => Home(),
      OpenContent.routeName: (context) => OpenContent(),
      SearchClass.routeName: (context) => SearchClass(),
      CfrnSchedule.routeName: (context) => CfrnSchedule(),
      AcjaSchedule.routeName: (context) => AcjaSchedule(),
      Bookmark.routeName: (context) => Bookmark(),
       About.routeName: (context) => About(),
       Alteration.routeName: (context) => Alteration()
    },
  ));
}

class SearchAcja {
  String txt;
  SearchAcja(String txt, BuildContext context) {
    this.txt = txt;

    List<Widget> searchContent = [];

    void performsearch() async {
      if (searchSection) {
        for (var i = 0; i < sectionSearchList.length; i++) {
          if (sectionSearchList[i]['id'] == int.parse(txt)) {
            int id = sectionSearchList[i]['id'];
            String title = sectionSearchList[i]['title'];

            searchContent.add(searchBar(context, id, title, contentData, txt));
            searchContent.add(SizedBox(
              height: 30.0,
            ));
          }
        }
      } else {
        for (var i = 0; i < contentData.length; i++) {
          if (contentData[i]['content']
              .toLowerCase()
              .contains(txt.toLowerCase())) {
            var section = sectionSearchList[contentData[i]['section_id']];
            var chapter = chapterSearchList[section['chapter_id']];
            String content = contentData[i]['content'];

            searchContent.add(contentsearch(context, txt, content,
                chapter['title'], section['title'], null));
            searchContent.add(SizedBox(
              height: 30.0,
            ));
          }
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
