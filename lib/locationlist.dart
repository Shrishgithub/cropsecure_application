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
import 'package:cropsecure_application/chartdetail.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:cropsecure_application/listdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationListApp extends StatefulWidget {
  final int level1;
  final int level2;
  final int level3;
  final String userid;
  const LocationListApp(
      {required this.level1,
      required this.level2,
      required this.level3,
      required this.userid});

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

  // final List<Map<String, String>> locations = [];

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
          Constant.LocationList,
          ApiPayload.inst.locationList(
              widget.level1, widget.level2, widget.level3, widget.userid),
          {
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
          locations = locl.data;
          logSuccess('locations list', locations.toString());

          for (DatumLocList datum in locl.data) {
            state.add(datum.level1.toString());
            district.add(datum.level2.toString());
            block.add(datum.level3.toString());
          }
          logSuccess('state', state.toString());
          logSuccess('district', district.toString());
          logSuccess('block', block.toString());

          String sqlQuery1 =
              'SELECT * FROM ${SqlQuery.inst.Level1LocationTable} WHERE id IN (${List.filled(state.length, '?').join(', ')})';
          logInfo('StateQuery', sqlQuery1);
          logInfo('State Data', state.toString());
          List vv = await DB.inst.select(sqlQuery1, state);
          // Extract the names
          List<String> nameState =
              vv.map((row) => row['name'].toString()).toList();
          String Stname = nameState.join(', ');
          logInfo('State List', vv.toString());
          logInfo('States', Stname);

          String sqlQuery2 =
              'SELECT * FROM ${SqlQuery.inst.Level2LocationTable} WHERE Level2Id IN (${List.filled(district.length, '?').join(',')})';
          logInfo('Message2', sqlQuery2);
          logInfo('Message2', district.toString());
          List dd = await DB.inst.select(sqlQuery2, district);
          // Extract the district
          List<String> nameDistrict =
              dd.map((row) => row['Level2Name'].toString()).toList();
          String d11 = nameDistrict.join(', ');
          logInfo('Meesage1', dd.toString());
          logInfo('Meesage1', d11);

          String sqlQuery3 =
              'SELECT * FROM ${SqlQuery.inst.Level3LocationTable} WHERE Level3Id IN (${List.filled(block.length, '?').join(', ')})';
          logInfo('BlockQuery', sqlQuery3);
          logInfo('Block Data', block.toString());
          List bb = await DB.inst.select(sqlQuery3, block);
          // Extract the names
          List<String> nameBlock =
              bb.map((row) => row['Level3Name'].toString()).toList();
          String Blname = nameBlock.join(', ');
          logInfo('Block List', bb.toString());
          logInfo('Blocks', Blname);
          String getBlocName(int level3Id) {
            for (Map block in bb) {
              logError('calling', block['Level3Id'].toString());
              logError('calling', block['Level3Name'].toString());
              logInfo('name', level3Id.toString());
              if (int.parse(block['Level3Id']) == level3Id) {
                logError('calling', 'Internal');

                return block['Level3Name'];
              }
            }
            return '';
          }

          _rows = locations.map((location) {
            return DataRow(
                // onLongPress: () {
                //   Navigator.of(context).push(
                //       MaterialPageRoute(builder: (context) => ChartDetail()));
                // },
                cells: <DataCell>[
                  DataCell(Text(Stname)), //location.level1.toString()
                  DataCell(Text(d11)), //location.level2.toString()
                  DataCell(Text(getBlocName(
                      location.level3))), //location.level3.toString()
                  DataCell(Text(location.id.toString())),
                  DataCell(InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ChartDetail(location: location.locationId)));
                    },
                    child: Text(
                      location.name,
                      style: TextStyle(color: Colors.blue),
                    ),
                  )),
                  DataCell(Text(location.lat)),
                  DataCell(Text(location.lon)),
                ]);
          }).toList();
          setState(() {});
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
