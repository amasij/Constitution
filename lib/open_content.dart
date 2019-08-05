import 'package:flutter/material.dart';
import 'screen_arguments.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class OpenContent extends StatefulWidget {
  static String get routeName => '/extractArguments';

  @override
  OpenContentPage createState() => OpenContentPage();
}



class OpenContentPage extends State<OpenContent> {
  File jsonFile;
  Directory dir;
  String fileName = "bookmarks.json";
  bool fileExists = false;
  var keyId='\\';
  Map<String, dynamic> fileContent={};
  Icon bookmark = Icon(
  Icons.bookmark,
  color: Colors.white,
);
bool isBookmareked = false;

  @override
  void initState() {
    super.initState();
    /*to store files temporary we use getTemporaryDirectory() but we need
    permanent storage so we use getApplicationDocumentsDirectory() */
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists)
     //jsonFile.deleteSync();
    // return;
        this.setState(
            () {
              fileContent = json.decode(jsonFile.readAsStringSync());
              isBookmareked = fileContent.containsKey(keyId);
    if (isBookmareked)
    
      bookmark = Icon(
        Icons.bookmark,
        color: Colors.green,
      );
      setState(() {
        
      });

            } );
    });
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
   // print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

void removeBookmark(String keyId)
{
  fileContent.remove(keyId);
  createFile(fileContent, dir,fileName);
}

  void writeToFile(String key, dynamic value) {
  //  print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
    //  print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
     // print("File does not exist!");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    keyId = args.keyId;
    
    var content = args.content.split('@').where((i) {
      if (i.trim() == '')
        return false;
      else
        return true;
    }).toList();

Widget getCard(var content)
{
  List<Widget> contentWidget = [];
      for (var i = 0; i < content.length; i++) {


                 try {
              int.parse(content[i][1]);
             contentWidget.add( Card(
                child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(content[i]),
                ),
              ));
            } catch (e) {
              var check = false;
              if (content[i][0] == '(') check = true;
             contentWidget.add(Card(
                child: Padding(
                  padding: check
                      ? EdgeInsets.only(left: 15.0, top: 4.0, bottom: 4.0)
                      : EdgeInsets.all(7.0),
                  child: Text(content[i]),
                ),
              ));
            }

      //contentWidget.add(
      // Text( content[i])
       //  );
      contentWidget.add(SizedBox(
        height: 15.0,
      ));
    }
    return Card(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: contentWidget,
        ),
      ),
    );
}
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
        backgroundColor: Colors.greenAccent[600],
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(
            icon: bookmark,
            onPressed: () {
              if (!isBookmareked) {
                Toast.show("Bookmark Added", context, gravity: Toast.BOTTOM,backgroundColor: Colors.green);
                isBookmareked = true;
                bookmark = Icon(
                  Icons.bookmark,
                  color: Colors.green,
                );
                writeToFile(keyId, content);
              } else {
                Toast.show("Bookmark Removed", context, gravity: Toast.BOTTOM);
                isBookmareked = false;
                bookmark = Icon(
                  Icons.bookmark,
                  color: Colors.white,
                );
                
                
                removeBookmark(keyId);
              }
              setState(() {});
             // print(isBookmareked);
            },
          )
        ],
      ),
      body: Theme(
          data: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.greenAccent[600],
              accentColor: Colors.greenAccent[400],
              indicatorColor: Colors.green[700],

              // Define the default font family.
              fontFamily: 'Montserrat',
              textTheme: TextTheme(
                body1: TextStyle(fontSize: 17.0, fontFamily: 'Hind'),
              )),
          child: SingleChildScrollView(child: getCard(content),)
          ),
    );
  }
}
