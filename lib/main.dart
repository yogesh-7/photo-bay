import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirstPage(),
  ));
}

class FirstPage extends StatelessWidget {
  var _categoryNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
              ),
              new Image.asset(
                'images/photobay.png',
                width: 200.0,
                height: 200.0,
              ),
              new ListTile(
                title: new TextFormField(
                  controller: _categoryNameController,
                  decoration: new InputDecoration(
                      labelText: 'Enter a Category',
                      hintText: 'eg: dogs, bikes, cats...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
              ),
              new ListTile(
                title: new Material(
                  color: Colors.lightBlue,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  child: new MaterialButton(
                    height: 47.5,
                    onPressed: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context){
                          return new SecondPage(category: _categoryNameController.text,);
                        })
                      );
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  String category;
  SecondPage({this.category});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Photo Bay', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: new FutureBuilder(
          future: getPics(widget.category),
          builder: (context, snapshot) {
            Map data = snapshot.data;
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text(
                'Failded to get response from the server',
                style: TextStyle(color: Colors.red, fontSize: 22.0),
              );
            } else if (snapshot.hasData) {
              return new Center(
                child: new ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return new Column(
                        children: <Widget>[
                          new Container(
                            child: new InkWell(
                              onTap: () {},
                              child: new Image.network(
                                  '${data['hits'][index]['largeImageURL']}'),
                            ),
                          ),
                          new Padding(padding: const EdgeInsets.all(5.0)),
                        ],
                      );
                    }),
              );
            } else if (!snapshot.hasData) {
              return new Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Future<Map> getPics(String category) async {
  String url = 'https://pixabay.com/api/?key=$apiKey&q=$category&image_type=photo&pretty=true';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
