import 'dart:convert';

import 'package:cropsecure_application/Model/chartdetailmodel.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/dateformat.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/chartdetail.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataSetUI extends StatefulWidget {
  final String name;
  List<ChartData> data1;
  List<ChartData> data2;
  DataSetUI({required this.name, required this.data1, required this.data2});

  @override
  State<DataSetUI> createState() => _DataSetUIState();
}

class _DataSetUIState extends State<DataSetUI> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 254, 249, 245),
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: Icon(Icons.filter_alt_rounded),
                  //     )
                  //   ],
                  // )
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
            height: 400,
            padding: EdgeInsets.all(16.0),
            child: SfCartesianChart(
              // title: ChartTitle(text: 'Wind Speed Data'),
              legend: Legend(
                  isVisible: true,
                  isResponsive: true,
                  position: LegendPosition.top),
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(
                labelRotation: -45,
                majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value} mps',
                majorGridLines: MajorGridLines(width: 0.5),
                axisLine: AxisLine(width: 0),
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                enableDoubleTapZooming: true,
                maximumZoomLevel: 3,
                enableMouseWheelZooming: true,
                enableSelectionZooming: true,
              ),
              series: <ChartSeries>[
                SplineSeries<ChartData, String>(
                  name: 'MaxWindSpeed',
                  dataSource: widget.data1,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                SplineSeries<ChartData, String>(
                  name: 'AverageWindSpeed',
                  dataSource: widget.data2,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
              ],
            ),
          )
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
            getChartData();
            setState(() {});
          },
          child: Text(param),
        ),
        if (checkday)
          Container(
            width: 1,
            height: 20,
            color: Colors.black12,
          )
      ],
    );
  }

  Future<void> getChartData() async {
    String token = await SharePref.shred.getString('token');
    logSuccess('token', token);
    try {
      var data = await APIResponse.data.postApiRequest(Constant.LocationData, {
        "location_id": "6548d6a19e64505b18014b63",
        "from_date": "2024-06-08",
        "to_date": dateFormatTodayDate(),
        "parameters": [
          {"id": "MinTemp", "name": "Min Temp"},
          {"id": "MaxTemp", "name": "Max Temp"},
          {"id": "MinMoisture", "name": "Min Hum"},
          {"id": "Rain", "name": "Instant Rain"},
          {"id": "CumulativeRain", "name": "Cumulative Rain"},
          {"id": "MaxWindSpeed", "name": "Max WindSpeed"},
          {"id": "AverageWindSpeed", "name": "Average WindSpeed"},
          {"id": "MaxAtmPres", "name": "Max Atm. Pressure"},
          {"id": "MinAtmPres", "name": "Min Atm. Pressure"},
          {"id": "AverageAtmPres", "name": "Average Atm. Pressure"},
          {"id": "AverageSolarRadiation", "name": "Average Solar Radiation"},
          {"id": "PM2_5", "name": "Average PM 2.5"},
          {"id": "PM10_0", "name": "Average PM 10.0"},
          {"id": "VOC", "name": "Average VOC"},
          {"id": "NOX", "name": "Average NOX"}
        ],
        "userId": "633"
      }, {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (data != '401' && data != 'No Data') {
        data = jsonDecode(data);
        logSuccess('Location Data', data.toString());
        Chart cc = Chart.fromMap(data);

        if (cc.status == 'success') {
          List<ChartData> maxWindSpeed = [];
          List<ChartData> averageWindSpeed = [];

          for (var wind in cc.data.windspeedData) {
            String date = wind.deviceDate.toString();
            maxWindSpeed.add(ChartData(
                date.toString(), double.parse(wind.maxWindSpeed.toString())));
            averageWindSpeed.add(ChartData(
                date.toString(), double.parse(wind.averageWindSpeed)));
          }

          setState(() {
            widget.data1 = maxWindSpeed;
            widget.data2 = averageWindSpeed;
          });

          toastMsg('Data Loaded Successfully');
        } else {
          handleTokenExpired();
        }
      } else {
        handleTokenExpired();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void handleTokenExpired() {
    toastMsg('Access Token Expired, Please login again!!');
    SharePref.shred.setBool('islogin', false);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (Route route) => false);
  }
}
