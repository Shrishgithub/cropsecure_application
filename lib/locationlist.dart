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
import 'package:cropsecure_application/chartdataset.dart';
import 'package:cropsecure_application/homepage.dart';
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
    super.initState();
    Future.delayed(Duration(microseconds: 500), getLocationList);
  }

  List<DatumLocList> locations = [];
  List<DatumLocList> locationFilter = [];
  List<DataRow> _rows = [];
  List<DataRow> _filteredRows = [];

  /*USE VARIABLE FOR API RESPONSE AND FITTER*/
  String stName = '';
  String dtName = '';
  List blockListDB = [];

  TextEditingController searchController = TextEditingController();

  void _filterLocations(String query) {
    logInfo("Query", query);
    locationFilter = locations
        .where((element) =>
            getBlocName(element.level3).toLowerCase().contains(query) ||
            element.name.toLowerCase().contains(query))
        .toList();
    setState(() {});
  }

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
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Location List",
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search location...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (query) {
                _filterLocations(query);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              columnSpacing: 30,
              headingRowHeight: 45,
              dataRowHeight: 30,
              border: TableBorder.symmetric(
                  inside: BorderSide(width: 1, color: Colors.grey),
                  outside: BorderSide(width: 1)),
              columns: const [
                DataColumn(label: Text('S No')),
                DataColumn(label: Text('State')),
                DataColumn(label: Text('District')),
                DataColumn(label: Text('Block')),
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Latitude')),
                DataColumn(label: Text('Longitude')),
              ],
              rows: locationFilter.map((location) {
                return DataRow(cells: <DataCell>[
                  DataCell(Text((locations.indexOf(location) + 1).toString())),
                  DataCell(Text(stName)),
                  DataCell(Text(dtName)),
                  DataCell(Text(getBlocName(location.level3))),
                  DataCell(Text(location.id.toString())),
                  DataCell(InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChartDataSet(
                              location: location.locationId,
                              locNam: location.name)));
                    },
                    child: Text(
                      location.name,
                      style: TextStyle(color: Colors.blue),
                    ),
                  )),
                  DataCell(Text(location.lat)),
                  DataCell(Text(location.lon)),
                ]);
              }).toList()),
        ),
      ),
    );
  }

  String getBlocName(int level3Id) {
    for (Map block in blockListDB) {
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
          locationFilter = locations;
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
          List<String> stateName =
              vv.map((row) => row['name'].toString()).toList();
          stName = stateName.join(', ');
          logInfo('State List', vv.toString());
          logInfo('States', stName);

          String sqlQuery2 =
              'SELECT * FROM ${SqlQuery.inst.Level2LocationTable} WHERE Level2Id IN (${List.filled(district.length, '?').join(',')})';
          logInfo('Message2', sqlQuery2);
          logInfo('Message2', district.toString());
          List dd = await DB.inst.select(sqlQuery2, district);
          List<String> nameDistrict =
              dd.map((row) => row['Level2Name'].toString()).toList();
          dtName = nameDistrict.join(', ');
          logInfo('Meesage1', dd.toString());
          logInfo('Meesage1', dtName);

          String sqlQuery3 =
              'SELECT * FROM ${SqlQuery.inst.Level3LocationTable} WHERE Level3Id IN (${List.filled(block.length, '?').join(', ')})';
          logInfo('BlockQuery', sqlQuery3);
          logInfo('Block Data', block.toString());
          blockListDB = await DB.inst.select(sqlQuery3, block);
          List<String> nameBlock =
              blockListDB.map((row) => row['Level3Name'].toString()).toList();
          String Blname = nameBlock.join(', ');
          logInfo('Block List', blockListDB.toString());
          logInfo('Blocks', Blname);
          // String getBlocName(int level3Id) {
          //   for (Map block in blockListDB) {
          //     logError('calling', block['Level3Id'].toString());
          //     logError('calling', block['Level3Name'].toString());
          //     logInfo('name', level3Id.toString());
          //     if (int.parse(block['Level3Id']) == level3Id) {
          //       logError('calling', 'Internal');
          //       return block['Level3Name'];
          //     }
          //   }
          //   return '';
          // }

          _rows = locations.map((location) {
            return DataRow(cells: <DataCell>[
              DataCell(Text((locations.indexOf(location) + 1).toString())),
              DataCell(Text(stName)),
              DataCell(Text(dtName)),
              DataCell(Text(getBlocName(location.level3))),
              DataCell(Text(location.id.toString())),
              DataCell(InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChartDataSet(
                          location: location.locationId,
                          locNam: location.name)));
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
          _filteredRows = _rows;
          setState(() {});
        }

        dialogClose(context);
      } else {
        toastMsg('Access Token Expired, Please login again!!');
        SharePref.shred.setBool('islogin', false);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route route) => false);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
