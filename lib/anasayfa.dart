import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iller_ve_ilceler/il.dart';
import 'package:iller_ve_ilceler/ilce.dart';

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<Il> iller = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jsonCozumle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          "İller ve İlçeler",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: iller.length,
        itemBuilder: _listeOgesiniOlustur,
      ),
    );
  }

  Widget _listeOgesiniOlustur(BuildContext context, int index) {
    return Card(
      elevation: 5,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(iller[index].isim),
            Text(iller[index].plakaKodu),
          ],
        ),
        leading: Icon(Icons.location_city_outlined),
        children: iller[index].ilceler.map((ilce) {
          return ListTile(
            title: Text(ilce.isim),
          );
        }).toList(),
      ),
    );
  }

  void _jsonCozumle() async {
    String jsonString =
        await rootBundle.loadString("assets/iller_ilceler.json");
    Map<String, dynamic> illerMap = json.decode(jsonString);

    for (String plakaKodu in illerMap.keys) {
      Map<String, dynamic> ilMap = illerMap[plakaKodu];
      String ilIsmi = ilMap["name"];
      Map<String, dynamic> ilcelerMap = ilMap["districts"];

      List<Ilce> tumIlceler = [];

      for (String ilceKodu in ilcelerMap.keys) {
        Map<String, dynamic> ilceMap = ilcelerMap[ilceKodu];
        String ilceIsmi = ilceMap["name"];
        Ilce ilce = Ilce(ilceIsmi);
        tumIlceler.add(ilce);
      }

      Il il = Il(ilIsmi, plakaKodu, tumIlceler);
      iller.add(il);
    }
    setState(() {});
  }
}
