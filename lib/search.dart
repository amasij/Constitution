import 'package:flutter/material.dart';
import 'screen_arguments.dart';
import 'open_content.dart';
import 'content_search.dart';

Widget searchBar(
    BuildContext context, int id, String title, var contentData, String query) {
  return ListTile(
    title: Container(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
            children: getSpans(title, query, TextStyle(color: Colors.green)),
          ),
        ),
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2.0, color: Colors.black12)),
      ),
    ),
    onTap: () {
      //  Navigator.pushNamed(context, '/OpenContent');
      Navigator.pushNamed(context, OpenContent.routeName,
          arguments: ScreenArguments(title, getContent(id, contentData),title));
    },
  );
}

String getContent(int id, var contentData) {
  for (var i = 0; i < contentData.length; i++) {
    if (contentData[i]['section_id'] == id) return contentData[i]['content'];
  }
  return '';
}

 getChapter(int id, var chapterData) {
  for (var i = 0; i < chapterData.length; i++) {
    if (chapterData[i]['id'] == id) return chapterData[i];
  }
  return '';
}

getSection(int id,var sectionData)
{
    for (var i = 0; i < sectionData.length; i++) {
    if (sectionData[i]['id'] == id) return sectionData[i];
  }
  return '';
}

getPart(int id, var partData) {
  for (var i = 0; i < partData.length; i++) {
    if (partData[i]['id'] == id) return partData[i];
  }
  return '';
}

class SearchClass extends StatefulWidget {
  static String get routeName => '/aa';
  @override
  SearchClassState createState() => SearchClassState();
}

class SearchClassState extends State<SearchClass> {
  @override
  Widget build(BuildContext context) {
    final SearchArgs args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.query),
          backgroundColor: Colors.greenAccent[600],
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          top: true,
          child:  Column(
              children: <Widget>[
                Expanded(
                    child: args.searchresult.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return args.searchresult[index];
                            },
                            itemCount: args.searchresult.length,
                          )
                        : Center(child: Text('No result')))
              ],
            ),
          ),
        );
  }
}
