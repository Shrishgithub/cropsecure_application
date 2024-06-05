import 'dart:convert';
import 'dart:developer';

import 'package:cropsecure_application/Database/db.dart';
import 'package:cropsecure_application/Database/sqlquery.dart';
import 'package:cropsecure_application/Model/level1listmodel.dart';
import 'package:cropsecure_application/Model/level3listmodel.dart';
import 'package:cropsecure_application/Model/locationcount.dart';
import 'package:cropsecure_application/Utils/api_payload.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/Utils/spinkit.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:cropsecure_application/leveldialog.dart';
import 'package:cropsecure_application/locationlist.dart';
import 'package:cropsecure_application/main.dart';
import 'package:cropsecure_application/Model/level2listmodel.dart';
import 'package:cropsecure_application/mapscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListData extends StatefulWidget {
  const ListData({Key? key}) : super(key: key);

  @override
  State<ListData> createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<DataRow> _rows = [];
  List<ChartData> _chartData = [];
  String total = '';

  // static _ListDataState list = _ListDataState();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), getStateData);
    // getStateData();
    // getLocationCount();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            SharePref.shred.setBool('islogin', false);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyHomePage()),
                (Route route) => false);
          },
        ),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Card(
                  //Color(0xFFfef9f5),
                  color: const Color.fromARGB(255, 254, 249, 245),
                  elevation: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: w,
                          // height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  // getStateData(); // remove it when not in trial use
                                  // Add your onPressed logic here
                                  await _callDialog(context);
                                },
                                child: Icon(Icons.filter_alt_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 350,
                        width: w,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: DataTable(
                                columnSpacing: 30,
                                //Use this to set heading height.
                                headingRowHeight: 40,

                                dataRowHeight: 30,
                                border: TableBorder.all(),
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'State',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'District',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Block',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'AWS/ARG',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: _rows,
                                // <DataRow>[
                                //   DataRow(
                                //     cells: <DataCell>[
                                //       DataCell(Text('John')),
                                //       DataCell(Text('30')),
                                //       DataCell(Text('Developer')),
                                //     ],
                                //   ),
                                //   DataRow(
                                //     cells: <DataCell>[
                                //       DataCell(Text('Emily')),
                                //       DataCell(Text('28')),
                                //       DataCell(Text('Designer')),
                                //     ],
                                //   ),
                                // ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: const Color.fromARGB(255, 254, 249, 245),
                  elevation: 4,
                  child: GestureDetector(
                    onTap: () {
                      // Handle tap action here
                      print('Circular chart tapped!');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 300,
                        child: SfCircularChart(
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                                widget: Container(
                              child: Text(total),
                            ))
                          ],
                          legend: Legend(
                              isVisible: true,
                              isResponsive: true,
                              position: LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                                dataSource: _chartData,
                                // <ChartData>[
                                //   ChartData('Alpha', 10),
                                //   ChartData('Beta', 20),
                                //   ChartData('Cricket', 30),
                                // ],
                                xValueMapper: (ChartData data, _) =>
                                    data.category,
                                yValueMapper: (ChartData data, _) => data.value,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    // Positioning the data label
                                    labelPosition:
                                        ChartDataLabelPosition.outside)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              color: const Color.fromARGB(255, 254, 249, 245),
              elevation: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Temprature & Humidity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                                child: Icon(Icons.filter_alt_rounded),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Add your onPressed logic here
                        },
                        child: Text('1D'),
                      ),
                    ],
                  ),
                  Container(
                    // height: 300,
                    // padding: EdgeInsets.all(16.0),
                    child: SfCartesianChart(
                      legend: Legend(
                          isVisible: true,
                          isResponsive: true,
                          position: LegendPosition.top),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        FastLineSeries<ChartData, String>(
                          name: 'Max Temp',
                          dataSource: <ChartData>[
                            ChartData('Jan', 35),
                            ChartData('Feb', 28),
                            ChartData('Mar', 34),
                            ChartData('Apr', 32),
                            ChartData('May', 40),
                          ],
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.value,
                        ),
                        FastLineSeries<ChartData, String>(
                          name: 'Min Temp',
                          dataSource: <ChartData>[
                            ChartData('Jan', 0),
                            ChartData('Feb', 10),
                            ChartData('Mar', 20),
                            ChartData('Apr', 30),
                            ChartData('May', 40),
                          ],
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.value,
                        ),
                        FastLineSeries<ChartData, String>(
                          name: 'Humidity',
                          dataSource: <ChartData>[
                            ChartData('Jan', 100),
                            ChartData('Feb', 0),
                            ChartData('Mar', 43),
                            ChartData('Apr', 71),
                            ChartData('May', 22),
                          ],
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.value,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 254, 249, 245),
              elevation: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rainfall',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                                child: Icon(Icons.filter_alt_rounded),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(16.0),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        SplineSeries<ChartData, String>(
                          dataSource: <ChartData>[
                            ChartData('Jan', 35),
                            ChartData('Feb', 28),
                            ChartData('Mar', 34),
                            ChartData('Apr', 32),
                            ChartData('May', 40),
                          ],
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.value,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getStateData() async {
    List<String> state = [];
    try {
      dialogLoader(context, 'please wait...');
      String token = await SharePref.shred.getString('token');
      log('$token', name: 'token1');
      var data = await APIResponse.data.postApiRequest(Constant.Level1Data,
          ApiPayload.inst.level1(await SharePref.shred.getString('user_id')), {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (data != '401' && data != "NoData") {
        data = jsonDecode(data);
        print(data);
        Leve1List ll = Leve1List.fromMap(data);
        logSuccess('Success', ll.status);
        // if (data['status'] == 'success') {
        //   log(data['data'].toString(), name: 'Level1List');
        // }
        if (ll.status == 'success') {
          DB.inst.delete(SqlQuery.inst.Level1LocationTable, null, null);
          DB.inst.batchInsert(SqlQuery.inst.Level1LocationTable, ll.data);
          List f1 =
              await DB.inst.selectTblName(SqlQuery.inst.Level1LocationTable);
          logSuccess('name', jsonEncode(f1));

          for (DatumL1 datum in ll.data) {
            state.add(datum.id.toString());
          }
          logSuccess('getStateDataID', state.toString());
          getDistrictData(state);
        } else {
          toastMsg('Access Token Expired, Please login again!!');
          SharePref.shred.setBool('islogin', false);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route route) => false);
        }
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

  // ijuhjgvcb

  Future<void> getDistrictData(List<String> state) async {
    List<String> district = [];
    try {
      String token = await SharePref.shred.getString('token');
      log('$token', name: 'token');
      var data = await APIResponse.data.postApiRequest(
          Constant.Level2Data,
          ApiPayload.inst
              .level2(await SharePref.shred.getString('user_id'), state),
          {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      if (data != '401' && data != 'NoData') {
        data = jsonDecode(data);
        print(data);
        Leve2List l2 = Leve2List.fromMap(data);
        logSuccess('Success', l2.status);
        if (l2.status == 'success') {
          await DB.inst.delete(SqlQuery.inst.Level2LocationTable, null, null);
          await DB.inst.batchInsert(SqlQuery.inst.Level2LocationTable, l2.data);
          List ff =
              await DB.inst.selectTblName(SqlQuery.inst.Level2LocationTable);
          logSuccess('name', jsonEncode(ff));

          for (DatumL2 datum in l2.data) {
            district.add(datum.level2Id.toString());
          }
          logSuccess('geDistrictDataID', district.toString());
          getBlockData(district);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getBlockData(List<String> district) async {
    String token = await SharePref.shred.getString('token');

    logInfo('token', '$token');
    var data = await APIResponse.data.postApiRequest(
        Constant.Level3Data,
        ApiPayload.inst
            .level3(await SharePref.shred.getString('user_id'), district),
        {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (data != '401' && data != 'NoData') {
      data = jsonDecode(data);
      print(data);
      Level3List l3 = Level3List.fromMap(data);
      logSuccess('Success', l3.status);
      if (l3.status == 'success') {
        await DB.inst.delete(SqlQuery.inst.Level3LocationTable, null, null);
        await DB.inst.batchInsert(SqlQuery.inst.Level3LocationTable, l3.data);
        List f3 =
            await DB.inst.selectTblName(SqlQuery.inst.Level3LocationTable);
        logSuccess('Block', jsonEncode(f3));
        _getFromDB();
      }
    }
  }

  Future<void> getLocationCount(Map<String, dynamic> selectedValues) async {
    List<String> state = [];
    List<String> district = [];
    List<String> block = [];
    String token = await SharePref.shred.getString('token');
    logInfo('token', '$token');
    var data = await APIResponse.data.postApiRequest(
        Constant.LocationCount,
        // ApiPayload.inst
        //     .locationCount(await SharePref.shred.getString('user_id')),
        selectedValues,
        {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (data != '401' && data != 'No Data') {
      data = jsonDecode(data);
      logSuccess('name0', data.toString());
      LocationCount lc = LocationCount.fromMap(data);
      logSuccess('Location Succes', lc.status);
      if (lc.status == 'success') {
        logError("name1", _rows.length.toString());
        for (DatumLocMdl datum in lc.data) {
          state.add(datum.level1.toString());
          district.add(datum.level2.toString());
          block.add(datum.level3.toString());
        }

        String sqlQuery1 =
            'SELECT * FROM ${SqlQuery.inst.Level1LocationTable} WHERE id IN (${List.filled(state.length, '?').join(', ')})';
        logInfo('Message1', sqlQuery1);
        logInfo('Message1', state.toString());
        List vv = await DB.inst.select(sqlQuery1, state);
        // Extract the names
        List<String> nameState =
            vv.map((row) => row['name'].toString()).toList();
        String name = nameState.join(', ');
        logInfo('Message1', vv.toString());
        logInfo('Message1', name);

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

        String getDistrictName(int level2Id) {
          for (Map district in dd) {
            logError('calling', district['Level2Id'].toString());
            logError('calling', district['Level2Name'].toString());
            logInfo('name', level2Id.toString());
            if (int.parse(district['Level2Id']) == level2Id) {
              logError('calling', 'Internal');

              return district['Level2Name'];
            }
          }
          return '';
        }

        // String sqlQuery3 =
        //     'SELECT * FROM ${SqlQuery.inst.Level3LocationTable} WHERE Level3Id IN (${List.filled(block.length, '?').join(',')})';
        // logInfo('Message3', sqlQuery3);
        // logInfo('Message3', block.toString());
        // List bb = await DB.inst.select(sqlQuery3, block);
        // // Extract the district
        // List<String> nameBLock =
        //     bb.map((row) => row['Level3Name'].toString()).toList();
        // String b11 = nameBLock.join(', ');
        // logInfo('Message3', bb.toString());
        // logInfo('Message3', b11);
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

        _rows = lc.data.map((datum) {
          LatLng location =
              LatLng(double.parse(datum.lat), double.parse(datum.lon));
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(
                name,
                textAlign: TextAlign.center,
              )), // State
              DataCell(Text(
                getDistrictName(datum.level2), //d11
                textAlign: TextAlign.start,
              )),
              DataCell(Text(
                getBlocName(datum.level3), //b11
                textAlign: TextAlign.start,
              )), // Block
              DataCell(Row(
                children: [
                  TextButton(
                      onPressed: () async {
                        String userId =
                            await SharePref.shred.getString('user_id');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LocationListApp(
                                level1: datum.level1,
                                level2: datum.level2,
                                level3: datum.level3,
                                userid: userId)));
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return LocationListApp();
                        //   },
                        // );
                      },
                      child: Text(datum.count)),
                  GestureDetector(
                    onTap: () async {
                      String userId =
                          await SharePref.shred.getString('user_id');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            level1: datum.level1,
                            level2: datum.level2,
                            level3: datum.level3,
                            userid: userId,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/google-maps.png', // Replace with the path to your image asset
                      width: 24.0,
                      height: 24.0,
                      // color: Colors.blue, // Optional: to tint the image
                    ),
                  )
                ],
              )), // AWS/ARG
            ],
          );
        }).toList();

        _chartData = lc.data.map((datum) {
          return ChartData(datum.name, int.parse(datum.count));
        }).toList();
        logError("name2", _rows.length.toString());
        total = lc.total.toString();
        // ignore: use_build_context_synchronously
        dialogClose(context);
        setState(() {});
      }
    }
  }

  Future<void> _callDialog(BuildContext context) async {
    Map<String, Object?> value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog();
      },
    );
    await getLocationCount(value); //pass the data after applying dialog filter
    print(value);
  }

  Future<void> _getFromDB() async {
    // get 1st id Data from DB using State
    String stateQuery = 'SELECT * FROM ${SqlQuery.inst.Level1LocationTable}';
    logSuccess('StateQuery', stateQuery);

    // Fetch the data from the database
    List result = await DB.inst.select(stateQuery, []);
    print('_getFromDB' + result.toString());

    // Check if result is not empty and retrieve the id
    if (result.isNotEmpty) {
      String firstStateId = result.first['id'].toString();
      print('First State ID: $firstStateId');

      // get Data from DB of District //
      _getDistrictQuery(firstStateId);
    } else {
      print('No states found in the database.');
    }
  }

  Future<void> _getDistrictQuery(String firstStateId) async {
    String districtQuery = 'SELECT * FROM ${SqlQuery.inst.Level2LocationTable}';
    logSuccess('StateQuery', districtQuery);

    // Fetch the data from the database
    List result = await DB.inst.select(districtQuery, []);
    print('_getDistrictFromDB' + result.toString());

    // Check if result is not empty and retrieve the id
    if (result.isNotEmpty) {
      int StateIdd = int.parse(firstStateId);
      String firstDistrictId = result.first['Level2Id'].toString();
      print('First District ID: $firstDistrictId');
      int DistrictIdd = int.parse(firstDistrictId);
      String UserId = await SharePref.shred.getString('user_id');

      final selectedValues = {
        "level1_id": StateIdd,
        "level2_id": [DistrictIdd],
        "userId": UserId
      };

      getLocationCount(selectedValues);
    } else {
      print('No District found in the database.');
    }
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
}
