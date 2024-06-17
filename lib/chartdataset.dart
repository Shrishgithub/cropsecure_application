import 'dart:convert';

import 'package:cropsecure_application/Model/chartdetailmodel.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/dateformat.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/Utils/spinkit.dart';
// import 'package:cropsecure_application/Utils/notinuse/temphumidity.dart';
import 'package:cropsecure_application/chartdetail.dart';
import 'package:cropsecure_application/homepage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDataSet extends StatefulWidget {
  final String location;
  const ChartDataSet({required this.location});

  @override
  State<ChartDataSet> createState() => _ChartDataSetState();
}

class _ChartDataSetState extends State<ChartDataSet> {
  // For Temprature
  List<ChartData> maxTempData = [];
  List<ChartData> minTempData = [];
  List<ChartData> minMoistureData = [];
  // For RainFall
  List<ChartData> rainfallData = [];
  List<ChartData> cumulativeRainData = [];
  // For WindSpeed
  List<ChartData> maxWindSpeedData = [];
  List<ChartData> avarageWindSpeedData = [];
  //For Atmospheric Pressure
  List<ChartData> averageAtmPresData = [];
  List<ChartData> averageSolarRadiationData = [];
  //For PmData
  List<ChartData> avgPm_2_5Data = [];
  List<ChartData> avgPm_10_0Data = [];
  //For VocNoxData
  List<ChartData> averageVOCData = [];
  List<ChartData> averageNOXData = [];

  String selectedDuration = '1D';
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
      body: maxTempData.isEmpty &&
              rainfallData.isEmpty &&
              maxWindSpeedData.isEmpty &&
              averageAtmPresData.isEmpty &&
              avgPm_2_5Data.isEmpty &&
              averageVOCData.isEmpty
          ? const NoDataFound()
          : ListView(
              children: [
                if (maxTempData.isNotEmpty)
                  DataSetUI(
                      location: widget.location,
                      selectedDur: '1D',
                      name: 'Temperature & Humidity',
                      value: '°C',
                      dataName1: 'Max Temp',
                      data1: maxTempData,
                      dataName2: 'Min Temp',
                      data2: minTempData,
                      dataName3: 'Min Moisture',
                      data3: minMoistureData,
                      onChange: printBack),
                if (rainfallData.isNotEmpty) //data3: minMoistureData
                  DataSetUI(
                      location: widget.location,
                      selectedDur: '1D',
                      name: 'Rainfall',
                      value: 'mm',
                      dataName1: 'Instant Rain',
                      data1: rainfallData,
                      dataName2: 'Cumulative Rain',
                      data2: cumulativeRainData,
                      dataName3: '',
                      data3: [],
                      onChange: printBack),
                if (maxWindSpeedData.isNotEmpty)
                  DataSetUI(
                      location: widget.location,
                      selectedDur: selectedDuration,
                      name: 'WindSpeed',
                      value: 'mps',
                      dataName1: 'MaxWindSpeed',
                      data1: maxWindSpeedData,
                      dataName2: 'AverageWindSpeed',
                      data2: avarageWindSpeedData,
                      dataName3: '',
                      data3: [],
                      onChange: printBack),
                if (averageAtmPresData.isNotEmpty)
                  DataSetUI(
                      location: widget.location,
                      selectedDur: selectedDuration,
                      name: 'Atmospheric Pressure',
                      value: 'atm',
                      dataName1: 'AverageAtmPres',
                      data1: averageAtmPresData,
                      dataName2: 'AverageSolarRadiation',
                      data2: averageSolarRadiationData,
                      dataName3: '',
                      data3: [],
                      onChange: printBack),
                if (avgPm_2_5Data.isNotEmpty)
                  DataSetUI(
                      location: widget.location,
                      selectedDur: selectedDuration,
                      name: 'PmData',
                      value: 'pm',
                      dataName1: 'AveragePm',
                      data1: avgPm_2_5Data,
                      dataName2: 'AverageSolarRadiation',
                      data2: avgPm_10_0Data,
                      dataName3: '',
                      data3: [],
                      onChange: printBack),
                if (averageVOCData.isNotEmpty)
                  DataSetUI(
                      location: widget.location,
                      selectedDur: selectedDuration,
                      name: 'VocNoxData',
                      value: 'vocnox',
                      dataName1: 'AverageVoc',
                      data1: averageVOCData,
                      dataName2: 'AverageNox',
                      data2: averageNOXData,
                      dataName3: '',
                      data3: [],
                      onChange: printBack),
              ],
            ),
    );
  }

  Future<void> getChartData() async {
    String token = await SharePref.shred.getString('token');
    logSuccess('token', token);
    try {
      dialogLoader(context, 'loading...');
      var data = await APIResponse.data.postApiRequest(Constant.LocationData, {
        "location_id": widget.location,
        "from_date": dateFormatTodayDate(),
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
        logSuccess('Location Data', jsonEncode(data));
        Chart cc = Chart.fromMap(data);

        if (cc.status == 'success') {
          List<ChartData> tempMax = [];
          List<ChartData> tempMin = [];
          List<ChartData> moistureMin = [];
          List<ChartData> rainfall = [];
          List<ChartData> cumulativeRainfall = [];
          List<ChartData> maxWindSpeed = [];
          List<ChartData> averageWindSpeed = [];
          List<ChartData> averageAtmPres = [];
          List<ChartData> averageSolarRadiation = [];
          List<ChartData> avgPm_2_5 = [];
          List<ChartData> avgPm_10_0 = [];
          List<ChartData> averageVOC = [];
          List<ChartData> averageNOX = [];

          for (var temp in cc.data.tempData) {
            String date = dateFormatLog(
                temp.deviceDate.toString()); //toIso8601String().split('T')[0]
            tempMax.add(ChartData(
                date.toString(), double.parse(temp.maxTemp.toString())));
            tempMin.add(ChartData(
                date.toString(), double.parse(temp.minTemp.toString())));

            moistureMin.add(ChartData(
                date.toString(), double.parse(temp.minMoisture.toString())));
          }

          for (var rain in cc.data.rainData) {
            // String date = rain.deviceDate.toIso8601String().split('T')[0];
            String date = dateFormatLog(rain.deviceDate.toString());
            rainfall.add(
                ChartData(date.toString(), double.parse(rain.rain.toString())));
            cumulativeRainfall.add(ChartData(
                date.toString(), double.parse(rain.cumulativeRain.toString())));
          }

          for (var wind in cc.data.windspeedData) {
            String date = dateFormatLog(wind.deviceDate.toString());
            maxWindSpeed.add(ChartData(
                date.toString(), double.parse(wind.maxWindSpeed.toString())));
            averageWindSpeed.add(ChartData(date.toString(),
                double.parse(wind.averageWindSpeed.toString())));
          }

          for (var atm in cc.data.atmPresData) {
            String date = dateFormatLog(atm.deviceDate.toString());
            averageAtmPres.add(ChartData(
                date.toString(), double.parse(atm.averageAtmPres.toString())));
            averageSolarRadiation.add(ChartData(date.toString(),
                double.parse(atm.averageSolarRadiation.toString())));
          }

          for (var pm in cc.data.pmData) {
            String date = dateFormatLog(pm.deviceDate.toString());
            avgPm_2_5.add(ChartData(
                date.toString(), double.parse(pm.avgPm25.toString())));
            avgPm_10_0.add(ChartData(
                date.toString(), double.parse(pm.avgPm100.toString())));
          }

          for (var vocnox in cc.data.vocNoxData) {
            String date = dateFormatLog(vocnox.deviceDate.toString());
            averageVOCData.add(ChartData(
                date.toString(), double.parse(vocnox.averageVoc.toString())));
            averageNOXData.add(ChartData(
                date.toString(), double.parse(vocnox.averageNox.toString())));
          }

          setState(() {
            maxTempData = tempMax;
            minTempData = tempMin;
            minMoistureData = moistureMin;
            rainfallData = rainfall;
            cumulativeRainData = cumulativeRainfall;
            maxWindSpeedData = maxWindSpeed;
            avarageWindSpeedData = averageWindSpeed;
            averageAtmPresData = averageAtmPres;
            averageSolarRadiationData = averageSolarRadiation;
            avgPm_2_5Data = avgPm_2_5;
            avgPm_10_0Data = avgPm_10_0;
            averageVOCData = averageVOC;
            averageNOXData = averageNOX;
            isLoading = false;
          });

          toastMsg('Data Loaded Successfully');
          dialogClose(context);
        } else {
          handleTokenExpired();
        }
      } else {
        handleTokenExpired();
      }
    } catch (e) {
      print('Error: $e');
      dialogClose(context);
    }
  }

  void handleTokenExpired() {
    toastMsg('Access Token Expired, Please login again!!');
    SharePref.shred.setBool('islogin', false);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (Route route) => false);
  }

  void printBack() {
    logError('testTop', selectedDuration.toString());
  }
}

class DataSetUI extends StatefulWidget {
  final String name;
  List<ChartData> data1;
  List<ChartData> data2;
  List<ChartData> data3;
  String value;
  String dataName1;
  String dataName2;
  String dataName3;
  String location;
  String selectedDur;
  Function onChange;

  DataSetUI(
      {required this.name,
      required this.data1,
      required this.data2,
      required this.value,
      required this.dataName1,
      required this.dataName2,
      required this.location,
      required this.data3,
      required this.dataName3,
      required this.selectedDur,
      required this.onChange});

  @override
  State<DataSetUI> createState() => _DataSetUIState();
}

class _DataSetUIState extends State<DataSetUI> {
  // String selectedDuration = '1D';

  @override
  Widget build(BuildContext context) {
    logError('test', widget.selectedDur);
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
              _selectday(widget.name, '1D', true),
              _selectday(widget.name, '5D', true),
              _selectday(widget.name, '1M', true),
              _selectday(widget.name, '6M', false),
            ],
          ),
          Container(
            height: 400,
            padding: EdgeInsets.only(left: 8, right: 8),
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
                labelFormat: '{value} ' + widget.value,
                majorGridLines: MajorGridLines(width: 0.5),
                axisLine: AxisLine(width: 0),
              ),
              // zoomPanBehavior: ZoomPanBehavior(
              //   enablePinching: true,
              //   enablePanning: true,
              //   enableDoubleTapZooming: true,
              //   maximumZoomLevel: 3,
              //   enableMouseWheelZooming: true,
              //   enableSelectionZooming: true,
              // ),
              series: <ChartSeries>[
                SplineSeries<ChartData, String>(
                  name: widget.dataName1,
                  dataSource: widget.data1,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                SplineSeries<ChartData, String>(
                  name: widget.dataName2,
                  dataSource: widget.data2,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                if (widget.data3.isNotEmpty)
                  SplineSeries<ChartData, String>(
                    name: widget.dataName3,
                    dataSource: widget.data3,
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

  Widget _selectday(String param, String date, bool checkday) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            // Add your onPressed logic here
            // getChartData();
            // if (param == 'Temperature & Humidity' && date == '5D') {
            getChartData(widget.location, param, date);
            // }
          },
          child: Text(date,
              style: TextStyle(
                  color:
                      widget.selectedDur == date ? Colors.green : Colors.blue)),
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

  Future<void> getChartData(String location, String param, String date) async {
    String fromdate = '';
    String token = await SharePref.shred.getString('token');
    logSuccess('token', token);
    try {
      if (date == '1D') {
        fromdate = dateFormatTodayDate();
        // setState(() {
        //   Text(
        //     date,
        //     style: const TextStyle(
        //       color: Colors.green,
        //       fontSize: 20.0,
        //     ),
        //   );
        // });
      } else if (date == '5D') {
        fromdate = dateFormatFiveDaysBefore();
      } else if (date == '1M') {
        fromdate = dateFormatOneMonthBefore();
      } else if (date == '6M') {
        fromdate = dateFormatSixMonthBefore();
      }
      dialogLoader(context, 'loading...');
      var data = await APIResponse.data.postApiRequest(Constant.LocationData, {
        "location_id": location,
        "from_date": fromdate,
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
        widget.selectedDur = date;
        widget.onChange();
        data = jsonDecode(data);
        logSuccess('Location Data', jsonEncode(data));
        Chart cc = Chart.fromMap(data);

        if (cc.status == 'success') {
          List<ChartData> tempMax = [];
          List<ChartData> tempMin = [];
          List<ChartData> moistureMin = [];
          List<ChartData> rainfall = [];
          List<ChartData> cumulativeRainfall = [];
          List<ChartData> maxWindSpeed = [];
          List<ChartData> averageWindSpeed = [];
          List<ChartData> averageAtmPres = [];
          List<ChartData> averageSolarRadiation = [];
          List<ChartData> avgPm_2_5 = [];
          List<ChartData> avgPm_10_0 = [];
          List<ChartData> averageVOC = [];
          List<ChartData> averageNOX = [];

          if (param == 'Temperature & Humidity') {
            for (var temp in cc.data.tempData) {
              String date = dateFormatLog(
                  temp.deviceDate.toString()); //toIso8601String().split('T')[0]
              tempMax.add(ChartData(
                  date.toString(), double.parse(temp.maxTemp.toString())));
              tempMin.add(ChartData(
                  date.toString(), double.parse(temp.minTemp.toString())));

              moistureMin.add(ChartData(
                  date.toString(), double.parse(temp.minMoisture.toString())));
            }
          } else if (param == "Rainfall") {
            for (var rain in cc.data.rainData) {
              // String date = rain.deviceDate.toIso8601String().split('T')[0];
              String date = dateFormatLog(rain.deviceDate.toString());
              rainfall.add(ChartData(
                  date.toString(), double.parse(rain.rain.toString())));
              cumulativeRainfall.add(ChartData(date.toString(),
                  double.parse(rain.cumulativeRain.toString())));
            }
          } else if (param == 'WindSpeed') {
            for (var wind in cc.data.windspeedData) {
              String date = dateFormatLog(wind.deviceDate.toString());
              maxWindSpeed.add(ChartData(
                  date.toString(), double.parse(wind.maxWindSpeed.toString())));
              averageWindSpeed.add(ChartData(date.toString(),
                  double.parse(wind.averageWindSpeed.toString())));
            }
          } else if (param == 'Atmospheric Pressure') {
            for (var atm in cc.data.atmPresData) {
              String date = dateFormatLog(atm.deviceDate.toString());
              averageAtmPres.add(ChartData(date.toString(),
                  double.parse(atm.averageAtmPres.toString())));
              averageSolarRadiation.add(ChartData(date.toString(),
                  double.parse(atm.averageSolarRadiation.toString())));
            }
          } else if (param == 'PmData') {
            for (var pm in cc.data.pmData) {
              String date = dateFormatLog(pm.deviceDate.toString());
              avgPm_2_5.add(ChartData(
                  date.toString(), double.parse(pm.avgPm25.toString())));
              avgPm_10_0.add(ChartData(
                  date.toString(), double.parse(pm.avgPm100.toString())));
            }
          } else if (param == 'VocNoxData') {
            for (var vd in cc.data.vocNoxData) {
              String date = dateFormatLog(vd.deviceDate.toString());
              averageVOC
                  .add(ChartData(date.toString(), double.parse(vd.averageVoc)));
              averageNOX
                  .add(ChartData(date.toString(), double.parse(vd.averageNox)));
            }
          }

          setState(() {
            switch (widget.name) {
              case 'Temperature & Humidity':
                widget.data1 = tempMax;
                widget.data2 = tempMin;
                widget.data3 = moistureMin;
                break;

              case 'Rainfall':
                widget.data1 = rainfall;
                widget.data2 = cumulativeRainfall;
                break;

              case 'WindSpeed':
                widget.data1 = maxWindSpeed;
                widget.data2 = averageWindSpeed;
                break;

              case 'Atmospheric Pressure':
                widget.data1 = averageAtmPres;
                widget.data2 = averageSolarRadiation;
                break;

              case 'PmData':
                widget.data1 = avgPm_2_5;
                widget.data2 = avgPm_10_0;
                break;

              case 'VocNoxData':
                widget.data1 = averageVOC;
                widget.data2 = averageNOX;
                break;
            }
          });

          toastMsg('Data Loaded Successfully');
          dialogClose(context);
        } else {
          handleTokenExpired();
        }
      } else {
        handleTokenExpired();
      }
    } catch (e) {
      print('Error: $e');
      dialogClose(context);
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

class NoDataFound extends StatefulWidget {
  const NoDataFound({super.key});

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        'assets/No Search Results.png',
        // height: 800,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}
