import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';


import 'package:ementa_cantina/Helpers/Constants.dart';
import 'package:ementa_cantina/Helpers/LocationHelpers.dart';
import 'package:ementa_cantina/Model/Ementa.dart';
import 'package:ementa_cantina/Model/EmentaDia.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../Model/Field.dart';
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
            if(!_dataAvailable || !_fetchingData)
               Text(_text),
            if (_fetchingData)
              const CircularProgressIndicator(),
            if (!_fetchingData && ementas.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: ementas.length,
                  separatorBuilder: (_, __) => const Divider(thickness: 2.0),
                  itemBuilder: (BuildContext context, int index) =>

                   Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 15),
                          child: Text(ementas[index].toShow.weekDay.value,
                              style: TextStyle(fontWeight: FontWeight.bold, color: getColorStyle(ementas[index].toShow.weekDay)),
                              textScaleFactor: 1.5
                          ),
                        ),
                        if (ementas[index].img != null)
                          Image.network(("${Constants.IMAGES_URL}${ementas[index].img}?${DateTime.now().millisecondsSinceEpoch.toString()}"),width: 400,height: 200, fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                    ),
                                  );
                              },
                              errorBuilder:(BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                                  return const Text("No available");}),

                         Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text("Soup: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text((ementas[index].toShow.soup.value),
                                        style: TextStyle(color: getColorStyle(ementas[index].toShow.soup)))
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text("Fish: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text((ementas[index].toShow.fish.value), style: TextStyle(color: getColorStyle(ementas[index].toShow.fish)))
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text("Meat: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text((ementas[index].toShow.meat.value), style: TextStyle(color: getColorStyle(ementas[index].toShow.meat)))
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:[
                                    const Text("Vegeterian: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text((ementas[index].toShow.vegetarian.value), style: TextStyle(color: getColorStyle(ementas[index].toShow.vegetarian)))
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:[
                                    const Text("Desert: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text((ementas[index].toShow.desert.value), style: TextStyle(color: getColorStyle(ementas[index].toShow.desert)))
                                  ]),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                  onPressed: () { onClick(ementas[index].toShow); },
                                child: const Text("Editar"),),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  )
                ),

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
      decodedData.forEach((key, value) {
        ementas.add(EmentaDia.fromJson(value));
      });
      setState(() {
        _dataAvailable = true;
        _fetchingData = false;
        _text = "";
        ementas = weekSort(ementas);
      });
    }else{
      setState(() {
        _text = "Não existem dados disponiveis";
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

      http.Response response = await http.get(Uri.parse(Constants.MENU_URL)).timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            return http.Response('Error', 408); // Request Timeout response status code
          });

      if (response.statusCode == HttpStatus.ok) {
        debugPrint(response.body);
        final Map<String, dynamic> decodedData = json.decode(utf8.decode(response.bodyBytes));
        storeDataOnSharedPreferences(utf8.decode(response.bodyBytes));
        ementas = [];
        decodedData.forEach((key, value) {
          ementas.add(EmentaDia.fromJson(value));
        });
        setState(() => {
          _text = "",
          ementas = weekSort(ementas)
        });

      }else{
        showSnackBar("Não foi possivel satisfazer o pedido");
      }
    } on SocketException catch (ex) {
      if(ex.osError != null && ex.osError?.errorCode == 111){
        showSnackBar("Não foi possivel atualizar");
      }else{
        showSnackBar("Sem conexão");
      }
      print(ex.osError);
    }
    catch(e){
      debugPrint('Something went wrong: $e');
    }
    finally {
      setState(() => _fetchingData = false);
    }
  }


  Color getColorStyle(Field field) {
    if(field.updated){
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

  Future<Widget> _fetchImage(String? img) async {
    http.Response response = await http.get(Uri.parse("${Constants.IMAGES_URL}$img")).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          return http.Response('Error', 408); // Request Timeout response status code
        });
    if (response.statusCode == HttpStatus.ok) {
      return Image.memory(response.bodyBytes,width: 400,height: 200, fit: BoxFit.cover,);
    }else{
      showSnackBar("Não foi possivel satisfazer o pedido");
    }
    return const Text("Imagem não foi possivel carregar");

  }

  Future<bool> getLocation() async {
    double latitudeIsec = 40.193125;
    double longitudeIsec = -8.41251;
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
    double distance = meterDistanceBetweenPoints(latitudeIsec, longitudeIsec, locationData.latitude!, locationData.longitude!);
    if( distance < 100){
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

  List<EmentaDia> weekSort(List<EmentaDia> ementas) {
    var currentWeekDay = DateFormat('EEEE').format(DateTime.now()).toUpperCase();
    List<EmentaDia> newEmentas = [];
    int dia = 0;

    for(var ementa in ementas){
      if(ementa.day == currentWeekDay){
        break;
      }
      dia++;
    }

    newEmentas = ementas.sublist(dia);
    if(dia != 0) {
      newEmentas.addAll(ementas.sublist(0, dia));
    }

    return newEmentas;
  }
}







