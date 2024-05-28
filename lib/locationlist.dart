import 'dart:convert';

import 'package:cropsecure_application/Database/db.dart';
import 'package:cropsecure_application/Database/sqlquery.dart';
import 'package:cropsecure_application/Model/loclist.dart';
import 'package:cropsecure_application/Utils/api_payload.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/Utils/spinkit.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:cropsecure_application/listdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationListApp extends StatefulWidget {
  const LocationListApp({super.key});

  @override
  State<LocationListApp> createState() => _LocationListAppState();
}

class _LocationListAppState extends State<LocationListApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(microseconds: 500), getLocationList);
  }

  List<DatumLocList> locations = [];
  List<DataRow> _rows = [];

  // final List<Map<String, String>> locations = [
  //   {
  //     'State': 'Uttar Pradesh',
  //     'District': 'Basti',
  //     'Block': 'Dubaulia',
  //     'Id': '21538',
  //     'Name': 'Dubauliya',
  //     'Latitude': '26.7003651',
  //     'Longitude': '82.4950377'
  //   },
  //   {
  //     'State': 'Uttar Pradesh',
  //     'District': 'Basti',
  //     'Block': 'Harraiya',
  //     'Id': '21552',
  //     'Name': 'Harraiya Ghat',
  //     'Latitude': '26.8056477',
  //     'Longitude': '82.4619967'
  //   },
  //   {
  //     'State': 'Uttar Pradesh',
  //     'District': 'Basti',
  //     'Block': 'Vikram Jot',
  //     'Id': '65479',
  //     'Name': 'Malauli Gosai',
  //     'Latitude': '26.7768775',
  //     'Longitude': '82.3223084'
  //   },
  //   {
  //     'State': 'Uttar Pradesh',
  //     'District': 'Basti',
  //     'Block': 'Vikram Jot',
  //     'Id': '65480',
  //     'Name': 'Sandalpura',
  //     'Latitude': '26.7943806',
  //     'Longitude': '82.2915299'
  //   },
  //   {
  //     'State': 'Uttar Pradesh',
  //     'District': 'Basti',
  //     'Block': 'Harraiya',
  //     'Id': '65482',
  //     'Name': 'Amari',
  //     'Latitude': '26.8266726',
  //     'Longitude': '82.4130373'
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            SharePref.shred.setBool('islogin', false);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ListData()),
                (Route route) => false);
          },
        ),
        title: const Text(
          "Location List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(columns: const [
            DataColumn(label: Text('State')),
            DataColumn(label: Text('District')),
            DataColumn(label: Text('Block')),
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Latitude')),
            DataColumn(label: Text('Longitude')),
          ], rows: _rows),
        ),
      ),
    );
  }

  Future<void> getLocationList() async {
    List<String> state = [];
    List<String> district = [];
    List<String> block = [];

    try {
      dialogLoader(context, 'fetching data...');
      String token = await SharePref.shred.getString('token');
      logInfo('token', token);
      var response = await APIResponse.data.postApiRequest(
          Constant.LocationList, ApiPayload.inst.locationList(), {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response != '401' && response != 'No Data') {
        response = jsonDecode(response);
        logSuccess('Location List Data', response.toString());

        LocList locl = LocList.fromMap(response);
        logSuccess('locl', locl.toString());

        if (locl.status == 'success') {
          setState(() {
            locations = locl.data;
            logSuccess('locations list', locations.toString());
          });
          for (DatumLocList datum in locl.data) {
            state.add(datum.level1.toString());
            district.add(datum.level2.toString());
            block.add(datum.level3.toString());
          }
          logSuccess('state', state.toString());
          logSuccess('district', district.toString());
          logSuccess('block', block.toString());

          String SqlQuery1 =
              'SELECT * FROM ${SqlQuery.inst.Level1LocationTable} WHERE id IN (${List.filled(state.length, '?').join(', ')})';
          logInfo('SqlQuery1 SELECT', SqlQuery1);

          _rows = locations.map((location) {
            return DataRow(cells: <DataCell>[
              DataCell(Text(
                  location.level1.toString())), //location.level1.toString()
              DataCell(Text(
                  location.level2.toString())), //location.level2.toString()
              DataCell(Text(location.level3.toString())),
              DataCell(Text(location.id.toString())),
              DataCell(Text(location.name)),
              DataCell(Text(location.lat)),
              DataCell(Text(location.lon)),
            ]);
          }).toList();
        }

        dialogClose(context);
      } else {
        logError('Location List data', 'Location List Not Found...');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
