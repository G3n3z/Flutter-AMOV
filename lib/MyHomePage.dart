import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ementa_cantina/Model/Ementa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String url = "http://0.0.0.0:8080";
  final String menu_path = "http://0.0.0.0:8080/menu";
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Ementa>? _ementas;
  bool _fetchingData = false;
  bool _dataAvailable = false;
  String _text = "";
  @override
  void initState() {
    super.initState();
    getDataOfSharedPreferences();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(!_dataAvailable)
               Text(_text),
            if (_fetchingData)
              const CircularProgressIndicator(),
            if (!_fetchingData && _ementas != null && _ementas!.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: _ementas!.length,
                  separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                  itemBuilder: (BuildContext context, int index) =>
                  //     ListTile(
                  //   leading: Icon(Icons.ac_unit_rounded),
                  //   title: Text('Ementa #$index'),
                  //   subtitle: Text(_ementas![index].day ?? "ABC"),
                  //   onTap: (){}//TODO: Criar nova pagina},
                  // )
                  GestureDetector(
                    onTap: (){
                      onClick(_ementas![index]);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 15),
                          child: Container(
                              child:Text(_ementas![index].day ?? "ABC",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: getColorStyle(_ementas![index])),
                                  textScaleFactor: 1.5
                              )
                          ),
                        ),
                        if (_ementas![index].img != null)
                          FutureBuilder<Uint8List?>(
                            future: _fetchImage(_ementas![index].img),
                            builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(snapshot.data!, width: 400,height: 200, fit: BoxFit.cover);
                              } else if (snapshot.hasError) {
                                return const Text('Oops, something happened');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        Row(
                          children: [

                            // Padding(
                            //   padding: const EdgeInsets.only(left: 25.0),
                            //   child: Container(
                            //     child: Icon(Icons.ac_unit_rounded),
                            //     height: 100,
                            //   ),
                            // ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Soup: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((_ementas![index].soup ?? "ABC"), style: TextStyle(color: getColorStyle(_ementas![index])))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Fish: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((_ementas![index].fish ?? "ABC"), style: TextStyle(color: getColorStyle(_ementas![index])))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Meat: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((_ementas![index].meat ?? "ABC"), style: TextStyle(color: getColorStyle(_ementas![index])))
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children:[
                                          Text("Vegeterian: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((_ementas![index].vegetarian ?? "ABC"), style: TextStyle(color: getColorStyle(_ementas![index])))
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children:[
                                          Text("Desert: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((_ementas![index].desert ?? "ABC"), style: TextStyle(color: getColorStyle(_ementas![index])))
                                        ]),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ElevatedButton(
                                        onPressed: () {  },
                                      child: Text("Editar"),),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ),
              )
          ],
        ),
      ),
      floatingActionButton:
        FloatingActionButton(
          onPressed: () => _updateData(),
          heroTag: null,
          tooltip: 'Update',
          child: const Icon(
              Icons.update
          ),
        ),

    );
  }


  Future<void> getDataOfSharedPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    String? list = prefs.getString("ListOfLunch");
    if (list != null) {
      debugPrint(list);
      final Map<String, dynamic> decodedData = json.decode(list);
      _ementas = [];
      setState(() {
        _dataAvailable = true;
        _fetchingData = false;
        _text = "";
        decodedData.forEach((key, value) {
          if (value["update"] != null) {
            _ementas?.add(Ementa.fromJson(value["update"], true));
          }else{
            _ementas?.add(Ementa.fromJson(value["original"], false));
          }
        });
      });
    }else{
      setState(() {
        _text = "No data available";
        _dataAvailable = false;
      });
    }
  }

  Future<void> storeDataOnSharedPreferences(String jsonString) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("ListOfLunch", jsonString);
  }

  Future <void> _updateData() async {
    try {
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse("http://192.168.1.65:8080/menu"));
      if (response.statusCode == HttpStatus.ok) {
        debugPrint(response.body);
        final Map<String, dynamic> decodedData = json.decode(utf8.decode(response.bodyBytes));
        storeDataOnSharedPreferences(response.body);
        _ementas = [];
        setState(() => {
          _text = "",
          decodedData.forEach((key, value) {
            if (value["update"] != null) {
              _ementas?.add(Ementa.fromJson(value["update"], true));
            }else{
              _ementas?.add(Ementa.fromJson(value["original"], false));
            }
          })
        });

      }
    } catch (ex) {
      debugPrint('Something went wrong: $ex');
    } finally {
      setState(() => _fetchingData = false);
    }
  }


  Color getColorStyle(Ementa ementa) {
    if(ementa.update == true){
      return Colors.teal.shade700;
    }
    return Colors.black87;
  }

  Future<void> onClick(Ementa ementaDia)async {
    final object = await Navigator.of(context).pushNamed("DetailsPage", arguments: ementaDia);
    bool successfully = object is bool ? object : false;

    if(successfully){
      _updateData();
    }
  }

  Future<Uint8List?> _fetchImage(String? img) async {
    http.Response response = await http.get(Uri.parse("http://192.168.1.65:8080/images/$img"));
    if (response.statusCode == HttpStatus.ok) {
      return response.bodyBytes;
    }  
    return null;
    
  }
}







