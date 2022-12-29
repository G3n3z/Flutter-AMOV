import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ementa_cantina/Model/Ementa.dart';
import 'package:ementa_cantina/Model/EmentaDia.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
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
  List<EmentaDia> ementas = [];
  bool _fetchingData = false;
  bool _dataAvailable = false;
  String _text = "";



  @override
  void initState() {
    super.initState();
    getDataOfSharedPreferences();
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
            if (!_fetchingData && ementas.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: ementas.length,
                  separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                  itemBuilder: (BuildContext context, int index) =>

                  GestureDetector(
                    onTap: (){
                      onClick(ementas[index].toShow!);
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 15),
                          child: Container(
                              child:Text(ementas[index].day ?? "ABC",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: getColorStyle(ementas[index].toShow!)),
                                  textScaleFactor: 1.5
                              )
                          ),
                        ),
                        if (ementas[index].img != null)
                          Image.network(("http://192.168.1.65:8080/images/${ementas[index].img}"),width: 400,height: 200, fit: BoxFit.cover),
                        Row(
                          children: [
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
                                          Text((ementas[index].toShow!.soup ?? "ABC"), style: TextStyle(color: getColorStyle(ementas![index].toShow!)))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Fish: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((ementas[index].toShow!.fish!), style: TextStyle(color: getColorStyle(ementas[index].toShow!)))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text("Meat: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((ementas[index].toShow!.meat ?? "ABC"), style: TextStyle(color: getColorStyle(ementas[index].toShow!)))
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children:[
                                          Text("Vegeterian: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((ementas[index].toShow!.vegetarian ?? "ABC"), style: TextStyle(color: getColorStyle(ementas[index].toShow!)))
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children:[
                                          Text("Desert: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text((ementas[index].toShow!.desert ?? "ABC"), style: TextStyle(color: getColorStyle(ementas[index].toShow!)))
                                        ]),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ElevatedButton(
                                        onPressed: () { onClick(ementas[index].toShow!); },
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
      ementas = [];
      setState(() {
        _dataAvailable = true;
        _fetchingData = false;
        _text = "";
        decodedData.forEach((key, value) {
          ementas.add(EmentaDia.fromJson(value));
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
      http.Response response = await http.get(Uri.parse("http://192.168.1.65:8080/menu")).timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            return http.Response('Error', 408); // Request Timeout response status code
          });
      if (response.statusCode == HttpStatus.ok) {
        debugPrint(response.body);
        final Map<String, dynamic> decodedData = json.decode(utf8.decode(response.bodyBytes));
        storeDataOnSharedPreferences(utf8.decode(response.bodyBytes));
        ementas = [];
        setState(() => {
          _text = "",

          decodedData.forEach((key, value) {
            ementas.add(EmentaDia.fromJson(value));
          })
        });

      }else{
        showSnackBar("Não foi possivel satisfazer o pedido");
      }
    } on SocketException catch (ex) {
      showSnackBar("Sem conexão");
    }
    catch(e){
      debugPrint('Something went wrong: $e');
    }
    finally {
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
    bool canContinue = await getLocation();
    if(!canContinue){
      return;
    }

    final object = await Navigator.of(context).pushNamed("DetailsPage", arguments: ementaDia);
    bool successfully = object is bool ? object : false;

    if(successfully){
      _updateData();
    }
  }

  Future<Uint8List?> _fetchImage(String? img) async {
    http.Response response = await http.get(Uri.parse("http://192.168.1.65:8080/images/$img")).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          return http.Response('Error', 408); // Request Timeout response status code
        });
    if (response.statusCode == HttpStatus.ok) {
      return response.bodyBytes;
    }else{
      showSnackBar("Não foi possivel satisfazer o pedido");
    }
    return null;
    
  }

  Future<bool> getLocation() async {
    double latitudeIsec = 40.1925;
    double longitudeIsec = -8.4116;
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        showSnackBar("Serviço de localização não está disponivel");
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        showSnackBar("Sem permissões para aceder à localização");
        return false;
      }
    }

    locationData = await location.getLocation();
    if((locationData.latitude! - latitudeIsec).abs() < 0.00050 && (locationData.longitude! - longitudeIsec).abs() < 0.0050) {
      return true;
    }
    showSnackBar("Apenas pode editar se estiver perto da Cantina do Isec");
    return false;
  }

  void showSnackBar(String text){
    ScaffoldMessenger.of(context).showSnackBar(getSnackBar(text));
  }

  SnackBar getSnackBar(String text){
     return SnackBar(
      content: Text( text));
  }
}







