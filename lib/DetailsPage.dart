import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ementa_cantina/CameraInst.dart';
import 'package:ementa_cantina/Model/EmentaDia.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

import 'CameraPage.dart';
import 'Teste.dart';
class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  late final Object? args = ModalRoute.of(context)?.settings.arguments;
  late final EmentaDia? ementaDia = args is EmentaDia ? args as EmentaDia : null;

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
    _controller_soup.text = ementaDia?.soup ?? "";
    _controller_fish.text = ementaDia?.fish ?? "";
    _controller_meat.text = ementaDia?.meat ?? "";
    _controller_vegetarian.text = ementaDia?.vegetarian ?? "";
    _controller_desert.text = ementaDia?.desert ?? "";

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
      appBar: AppBar(title: Text("Ementa: ${ementaDia?.weekDay}")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Soup",
                ),
                controller: _controller_soup,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Fish",
                ),
                controller: _controller_fish,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Meat",
                ),
                controller: _controller_meat,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Vegetarian",
                ),
                controller: _controller_vegetarian,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
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
    data["weekDay"] = ementaDia?.weekDay ?? "";
    data["soup"] = _controller_soup.text ?? "";
    data["fish"] = _controller_fish.text ?? "";
    data["meat"] = _controller_meat.text ?? "";
    data["vegetarian"] = _controller_vegetarian.text ?? "";
    data["desert"] = _controller_desert.text ?? "";
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
    }


    http.Response request = await http.post(Uri.parse("http://10.0.2.2:8080/menu"),
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
    //await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TakePictureScreen(camera:CameraInstance.getInstance()!.camera!)));
  }
}
