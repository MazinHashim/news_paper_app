import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Model/model.dart';

final String apiKey = "49d9f33dfe1e404f99e49fac8c4a2e1c";

Future<List<Sources>> fetchNewsSource() async{
  final response = await http.get("https://newsapi.org/v2/sources?apiKey=$apiKey");

  if(response.statusCode == 200){
    List sources = json.decode(response.body)['sources'];
    return sources.map((source) => new Sources.fromJson(source)).toList();
  } else {
    throw Exception("Failed To Load Source List");
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var listSources;
  GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Paper"),
        centerTitle: true,
      ),
      body: Center(
        child: RefreshIndicator(
          key: refreshKey,
          child: FutureBuilder(
            future: listSources,
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Text("Error : ${snapshot.error}");
              } else if(snapshot.hasData){
                List<Sources> sources = snapshot.data;
                return new ListView(
                  children: sources.map((source) => GestureDetector(
                    onTap: (){},
                    child: Card(
                      elevation: 1.0,
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            width: 100,
                            height: 140,
                            child: Icon(Icons.library_books, color: Colors.blueGrey, size: 80.0,)
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                                        child: Text("${source.name}", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  child: Text("${source.description}", style: TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold)),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                                  child: Text("${source.category} Category", style: TextStyle(color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                    ),
                  )).toList(),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          onRefresh: refreshListSource,
        )
      ),
    );
  }

  Future<Null> refreshListSource() async{

    setState(() {
     listSources = fetchNewsSource(); 
    });

    return null;
  }
}