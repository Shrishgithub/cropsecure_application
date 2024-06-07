import 'dart:async';
import 'dart:convert';

import 'package:cropsecure_application/Model/chartdetailmodel.dart';
import 'package:cropsecure_application/Utils/api_payload.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDetail extends StatefulWidget {
  final int location;
  // const ChartDetail({super.key});
  const ChartDetail({required this.location});

  @override
  State<ChartDetail> createState() => _ChartDetailState();
}

class _ChartDetailState extends State<ChartDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(microseconds: 500), getChartData);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
          "Chart Detail",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Card(
            color: const Color.fromARGB(255, 254, 249, 245),
            elevation: 4,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                    right: 8.0,
                  ),
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
                    _selectday('1D', true),
                    _selectday('5D', true),
                    _selectday('1M', true),
                    _selectday('6M', false),
                  ],
                ),
                Container(
                  // height: 300,
                  // padding: EdgeInsets.all(16.0),
                  child: SfCartesianChart(
                    // title: ChartTitle(text: 'Temprature & Humidity'),
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
                Row(
                  children: [
                    _selectday('1D', true),
                    _selectday('5D', true),
                    _selectday('1M', true),
                    _selectday('6M', false),
                  ],
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
    );
  }

  Widget _selectday(String param, bool checkday) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            // Add your onPressed logic here
          },
          child: Text(param),
        ),
        if (checkday)
          Container(
            width: 1,
            height: 20,
            color: Colors.black12,
            //
          )
      ],
    );
  }

  Future<void> getChartData() async {
    String token = await SharePref.shred.getString('token');
    try {
      var data = await APIResponse.data.postApiRequest(
          Constant.LocationData, ApiPayload.inst.ChartDetail(), {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (data != '401' && data != 'No Data') {
        data = jsonDecode(data);
        logSuccess('Location Data', data.toString());
        Chart cc = Chart.fromMap(data);

        if (cc.status == 'success') {
          toastMsg('success !!');
        } else {
          toastMsg('Access Token Expired, Please login again!!');
          SharePref.shred.setBool('islogin', false);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route route) => false);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
}
