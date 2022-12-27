import 'dart:convert';
import 'dart:io';

import 'package:ementa_cantina/Model/EmentaDia.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  void submitEmenta() {

  }
}
