import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'open_content.dart';
import 'screen_arguments.dart';
import 'search.dart';
import 'content_search.dart';
import 'cfrn_schedule.dart';
import 'entry.dart';
import 'alteration.dart';
final pageName='CFRN';
TextEditingController searchController = TextEditingController();

class Cfrn extends StatefulWidget {
  @override
  CfrnState createState() => CfrnState();
}

var contentData;
var sectionSearchList, chapterSearchList, partSearchList;
bool searchSection = true;
bool searchContent = false;

class CfrnState extends State<Cfrn> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static String get txt => null;
  updateKeepAlive();

  List<dynamic> mainData = <dynamic>[];

  loadChapterJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/cfrn_chapters.json');
  }

  loadSectionJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/cfrn_sections.json');
  }

  loadPartJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/cfrn_parts.json');
  }

  loadContentJson() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/cfrn_contents.json');
  }

  @override
  void initState() {
    this.loadChapterJson().then((var chapterJson) {
      this.loadSectionJson().then((var sectionJson) {
        this.loadPartJson().then((var partJson) {
          this.loadContentJson().then((var contentJson) {
            var chapterData = json.decode(chapterJson);
            var sectionData = json.decode(sectionJson);
            var partData = json.decode(partJson);
            contentData = json.decode(contentJson);
            sectionSearchList = sectionData;
            partSearchList = partData;
            chapterSearchList = chapterData;

            List<Entry> tempSections;
            List<Entry> tempParts;

            for (var i = 1; i < chapterData.length; i++) {
              tempParts = <Entry>[];
              if (chapterData[i]['id'] > 1 && chapterData[i]['id'] < 5) {
                for (var k = 1; k < sectionData.length; k++) {
                  if (sectionData[k]['chapter_id'] == chapterData[i]['id'])
                    tempParts.add(Entry(sectionData[k]['title'], level2,
                        sectionData[k]['id'], <Entry>[]));
                }
                mainData.add(Entry(chapterData[i]['title'], level0,
                    chapterData[i]['id'], tempParts));
                continue;
              }

              for (var j = 1; j < partData.length; j++) {
                tempSections = <Entry>[];

                for (var k = 1; k < sectionData.length; k++) {
                  if (sectionData[k]['part_id'] == partData[j]['id'])
                    tempSections.add(Entry(sectionData[k]['title'], level2,
                        sectionData[k]['id'], <Entry>[]));
                }
                if (partData[j]['chapter_id'] == chapterData[i]['id'])
                  tempParts.add(Entry(partData[j]['title'], level1,
                      partData[j]['id'], tempSections));
              }
              mainData.add(Entry(chapterData[i]['title'], level0,
                  chapterData[i]['id'], tempParts));
            }
            //Add schedules here
            mainData.add(ListTile(
          title: Text('Schedules'),
          onTap: () {
            Navigator.pushNamed(context, CfrnSchedule.routeName);
           //  Navigator.pushNamed(context, '/CfrnSchedule');
            
          },
        ));
                    mainData.add(ListTile(
          title: Text('Alteration Acts'),
          onTap: () {
            Navigator.pushNamed(context, Alteration.routeName);
           //  Navigator.pushNamed(context, '/CfrnSchedule');
            
          },
        ));
            setState(() {});
          });
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
          Search(value.trim(), context);
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
              child: 
            
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) 
                {
                  if(index>7)return mainData[index];
                  
                  
                  return CfrnEntryItem(mainData[index]);
                },
                    
                itemCount: mainData == null ? 0 : mainData.length,
              ),
              
          
          ),
        ],
      ),
    ));
  }
}

// The entire multilevel list displayed by this app.

const int level0 = 0;
const int level1 = 1;
const int level2 = 2;
String  headerTitles;
class CfrnEntryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     headerTitles='';
    Widget _buildTiles(Entry root) {
      
      if (root.children.isEmpty && root.level != level2)
        return ListTile(title: Text(root.title));
      if (root.children.isEmpty && root.level == level2)
        return ListTile(
          title: Text(root.title),
          onTap: () {
            
            //  Navigator.pushNamed(context, '/OpenContent');
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

  const CfrnEntryItem(this.entry);

  final Entry entry;
}

String getHeader(int sectionId)
{
  var section=getSection(sectionId,sectionSearchList);
  var tempStr='$pageName\n';
  var chapter=getChapter(section['chapter_id'], chapterSearchList);
  if(chapter!='')tempStr+=chapter['title']+'\n';
  if(section['part_id']!=0)
  {
      var part=getPart(section['part_id'],partSearchList);
  if(part!='')tempStr+=part['title']+'\n';
  }
  tempStr+=section['title'];
  
  return tempStr;

}
class Search {
  String txt;
  Search(String txt, BuildContext context) {
    this.txt = txt;

    List<Widget> searchContent = [];

    void performsearch() async {
      if (searchSection) {
        for (var i = 0; i < sectionSearchList.length; i++) {
          if (sectionSearchList[i]['id']
              ==int.parse(txt)
              ) {
            int id = sectionSearchList[i]['id'];
            String title = sectionSearchList[i]['title'];

            searchContent.add(searchBar(context, id, title, contentData, txt));
            searchContent.add(SizedBox(
              height: 5.0,
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
            var part = section['part_id'] == 0
                ? null
                : partSearchList[section['part_id']];
            String content = contentData[i]['content'];

            searchContent.add(contentsearch(
                context,
                txt,
                content,
                chapter['title'],
                section['title'],
                part == null ? null : part['title']));
            searchContent.add(SizedBox(
              height: 30.0,
            ));
          }
        }
      }
    }

    performsearch();

    Navigator.pushNamed(context, SearchClass.routeName,
        arguments: SearchArgs(searchContent, txt));
  }
}
