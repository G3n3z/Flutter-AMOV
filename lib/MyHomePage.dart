import 'dart:convert';
import 'dart:io';

import 'package:ementa_cantina/Model/EmentaDia.dart';
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
  List<EmentaDia>? _ementas;
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
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    title: Text('Ementa #$index'),
                    subtitle: Text(_ementas![index].day ?? "ABC"),
                    onTap: (){}//TODO: Criar nova pagina},
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
      _ementas = [];
      setState(() {
        _dataAvailable = true;
        _fetchingData = false;
      });
    }else{
      setState(() {
        _text = "No data available";
        _dataAvailable = false;
      });
    }
  }

  Future <void> _updateData() async {
    try {
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse("http://192.168.1.71:8080/menu"));
      if (response.statusCode == HttpStatus.ok) {
        debugPrint(response.body);
        final Map<String, dynamic> decodedData = json.decode(response.body);
        _ementas = [];
        setState(() {
          decodedData.forEach((key, value) {
            if (value["update"] != null) {
              _ementas?.add(EmentaDia.fromJson(value["update"]));
            }else{
              _ementas?.add(EmentaDia.fromJson(value["original"]));
            }
          });
        });
      }
    } catch (ex) {
      debugPrint('Something went wrong: $ex');
    } finally {
      setState(() => _fetchingData = false);
    }
  }
}







