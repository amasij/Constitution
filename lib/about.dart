import 'package:flutter/material.dart';

class About extends StatefulWidget {
  static String get routeName => '/aboutpage';

  @override
  AboutPage createState() => AboutPage();
}

class AboutPage extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About..'),
          backgroundColor: Colors.greenAccent[600],
          automaticallyImplyLeading: true,
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
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('ABOUT',
                                style: TextStyle(
                                    color: Colors.yellow[800],
                                    fontWeight: FontWeight.bold)),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                            'This is, first and foremost, in loving memory of Mr. Edward Zenioyi Omodia.'),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                            'there has a dearth of up-to-date soft copies of the Constitution of the Federal Republic of Nigeria (CFRN), 1999, as well as scarcity of a complete and easy-to-use version of the Administration of Criminal Justice Act (ACJA), 2015. Hence, the "CFRN 1999 and ACJA" was birthed to remedy this situation.'),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                            'This app has a search engine and is easy to navigate. It contains the 2018 amendments to the Nigeran Constitution and the various forms in the Schedules to the ACJA.'),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text('DISCLAIMER',
                                style: TextStyle(
                                    color: Colors.yellow[800],
                                    fontWeight: FontWeight.bold)),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                            'This app was made to help you gain access to, read, search and navigate through the Constitution and the ACJA and, being a product of human hands, some errors or omissions might exist. Thus, we or Black Group Technologies Limited are neither responsible nor liable for any errors or omissions in this app version of the Constitution and the ACJA.'),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text('Developed for',style: TextStyle(
                                    color: Colors.yellow[800],
                                    fontWeight: FontWeight.bold)),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),Row(
                          children: <Widget>[
                            Text('P. O. Omodia '),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text('patrickomodia@gmail.com'),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text('Developed By',
                                style: TextStyle(
                                    color: Colors.yellow[800],
                                    fontWeight: FontWeight.bold)),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text('BGT (www.bgt.ng)'),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                         Row(
                          children: <Widget>[
                            Text('blackgrouptechnologies@gmail.com'),
                            SizedBox()
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[Text('version 1.0',style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)), SizedBox()],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  )),
            )));
  }
}
