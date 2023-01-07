import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ementa_cantina/Helpers/Constants.dart';
import 'package:ementa_cantina/Model/Ementa.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'CameraPage.dart';
class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  late final Object? args = ModalRoute.of(context)?.settings.arguments;
  late final Ementa? ementaDia = args is Ementa ? args as Ementa : null;

  final TextEditingController _controller_soup = TextEditingController();
  final TextEditingController _controller_fish = TextEditingController();
  final TextEditingController _controller_meat = TextEditingController();
  final TextEditingController _controller_vegetarian = TextEditingController();
  final TextEditingController _controller_desert = TextEditingController();
  String? _img;
  String? _weekDay;
  String? _soup;
  String? _fish;
  String? _meat;
  String? _vegetarian;
  String? _desert;
  late String path;
  bool haveImage = false;
  @override
  void initState() {
    super.initState();

    _controller_soup.addListener(() { _soup =_controller_soup.text; });
  }
  @override
  void didChangeDependencies() {
    print("Aquixx");
    _controller_soup.text = ementaDia?.soup.value ?? "";
    _controller_fish.text = ementaDia?.fish.value ?? "";
    _controller_meat.text = ementaDia?.meat.value ?? "";
    _controller_vegetarian.text = ementaDia?.vegetarian.value ?? "";
    _controller_desert.text = ementaDia?.desert.value ?? "";

    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _controller_soup.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ementa: ${ementaDia?.weekDay.value}")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Soup",
                ),
                controller: _controller_soup,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Fish",
                ),
                controller: _controller_fish,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Meat",
                ),
                controller: _controller_meat,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Vegetarian",
                ),
                controller: _controller_vegetarian,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Desert",
                ),
                controller: _controller_desert,
              ),
            ),
            if (haveImage)
              Image.file(File(path)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () { getPicture(); },
                  child:const Icon(Icons.camera_alt_outlined)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () { resetEmenta(); },
                child:Text("Reset")
            )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () { submitEmenta(); },
                  child:Text("Send")
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> submitEmenta() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["weekDay"] = ementaDia?.weekDay.value ?? "";
    data["soup"] = _controller_soup.text;
    data["fish"] = _controller_fish.text;
    data["meat"] = _controller_meat.text;
    data["vegetarian"] = _controller_vegetarian.text;
    data["desert"] = _controller_desert.text;
    String base64string = "";
    if(haveImage && path != "") {
      try{
        File imagefile = File(path); //convert Path to File
        Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
        base64string = base64.encode(imagebytes);
      }catch(e){}
    }
    if (base64string != "") {
      data["img"] = base64string;
    }else{
      data["img"] = ementaDia?.img;
    }


    http.Response request = await http.post(Uri.parse(Constants.MENU_URL),
        headers: {'Content-Type': 'application/json; charset=UTF-8 '},
        body: jsonEncode( data)
    );

    if (request.statusCode == HttpStatus.created) {
      Navigator.of(context).pop(true);
    }else{
      print(request.body);
    }

  }

  Future<void> getPicture()async {

    final object = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => CameraPage()));
    path = object is String ? object : "";
    if (path != "") {
      setState(() {
        haveImage = true;
      });
    }
  }

  Future<void> resetEmenta()async{
    final Map<String, dynamic> data = <String, dynamic>{};
    data["weekDay"] = ementaDia?.weekDay.value ?? "";
    data["soup"] = "";
    data["fish"] = "";
    data["meat"] = "";
    data["vegetarian"] = "";
    data["desert"] = "";
    data["img"] = null;
    http.Response request = await http.post(Uri.parse(Constants.MENU_URL),
        headers: {'Content-Type': 'application/json; charset=UTF-8 '},
        body: jsonEncode( data)
    );
    if (request.statusCode == HttpStatus.created) {
      Navigator.of(context).pop(true);
    }else{
      print(request.body);
    }
  }
}













