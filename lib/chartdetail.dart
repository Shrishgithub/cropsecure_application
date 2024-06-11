import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cropsecure_application/Model/chartdetailmodel.dart';
import 'package:cropsecure_application/Utils/api_payload.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/homepage.dart';

class ChartDetail extends StatefulWidget {
  final String location;
  const ChartDetail({required this.location});

  @override
  State<ChartDetail> createState() => _ChartDetailState();
}

class _ChartDetailState extends State<ChartDetail> {
  List<ChartData> maxTempData = [];
  List<ChartData> minTempData = [];
  List<ChartData> minMoistureData = [];
  List<ChartData> rainfallData = [];
  List<ChartData> cumulativeRainData = [];
  List<ChartData> maxWindSpeedData = [];
  List<ChartData> avarageWindSpeedData = [];
  List<ChartData> averageAtmPresData = [];
  List<ChartData> averageSolarRadiationData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 500), getChartData);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (maxTempData.isNotEmpty) buildTemperatureHumidityCard(w),
                buildRainfallCard(w),
                buildWindspeedCard(w),
                buildAtmpresCard(w),
              ],
            ),
    );
  }

  Widget buildTemperatureHumidityCard(double w) {
    return Card(
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
                    'Temperature & Humidity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {
                  //         // Add your onPressed logic here
                  //       },
                  //       child: Icon(Icons.filter_alt_rounded),
                  //     ),
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
            child: SfCartesianChart(
              // title: ChartTitle(text: 'Temperature & Humidity Over Time'),
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
                labelFormat: '{value}°C',
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
                  name: 'Max Temp',
                  dataSource: maxTempData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                SplineSeries<ChartData, String>(
                  name: 'Min Temp',
                  dataSource: minTempData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                SplineSeries<ChartData, String>(
                  name: 'Min Moisture',
                  dataSource: minMoistureData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRainfallCard(double w) {
    return Card(
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
                  // Row(
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {
                  //         // Add your onPressed logic here
                  //       },
                  //       child: Icon(Icons.filter_alt_rounded),
                  //     ),
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
              // title: ChartTitle(text: 'Rainfall Over Time'),
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
                labelFormat: '{value} mm',
                majorGridLines: MajorGridLines(width: 0.5),
                axisLine: AxisLine(width: 0),
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                maximumZoomLevel: 3,
                enableMouseWheelZooming: true,
                enableSelectionZooming: true,
                enableDoubleTapZooming: true,
              ),
              series: <ChartSeries>[
                SplineSeries<ChartData, String>(
                  name: 'Instant Rain',
                  dataSource: rainfallData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                SplineSeries<ChartData, String>(
                  name: 'Cumulative Rain',
                  dataSource: cumulativeRainData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWindspeedCard(double w) {
    return Card(
      color: const Color.fromARGB(255, 254, 249, 245),
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: SizedBox(
              width: w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WindSpeed',
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
                  dataSource: maxWindSpeedData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                SplineSeries<ChartData, String>(
                  name: 'AverageWindSpeed',
                  dataSource: avarageWindSpeedData,
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

  Widget buildAtmpresCard(double w) {
    return Card(
      color: const Color.fromARGB(255, 254, 249, 245),
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: SizedBox(
              width: w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Atmospheric Pressure',
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
              // title: ChartTitle(text: 'Atmospheric pressure Over Time'),
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
                labelFormat: '{value} atm',
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
                // enableDoubleTapZooming: true,
              ),
              series: <ChartSeries>[
                SplineSeries<ChartData, String>(
                  name: 'AverageAtmPres',
                  dataSource: averageAtmPresData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  // markerSettings: MarkerSettings(isVisible: true),
                ),
                SplineSeries<ChartData, String>(
                  name: 'AverageSolarRadiation',
                  dataSource: averageSolarRadiationData,
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
        "to_date": "2024-06-08",
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
          List<ChartData> tempMax = [];
          List<ChartData> tempMin = [];
          List<ChartData> moistureMin = [];
          List<ChartData> rainfall = [];
          List<ChartData> cumulativeRainfall = [];
          List<ChartData> maxWindSpeed = [];
          List<ChartData> averageWindSpeed = [];
          List<ChartData> averageAtmPres = [];
          List<ChartData> averageSolarRadiation = [];

          for (var temp in cc.data.tempData) {
            String date =
                temp.deviceDate.toString(); //toIso8601String().split('T')[0]
            tempMax.add(ChartData(
                date.toString(), double.parse(temp.maxTemp.toString())));
            tempMin.add(ChartData(
                date.toString(), double.parse(temp.minTemp.toString())));

            moistureMin.add(ChartData(
                date.toString(), double.parse(temp.minMoisture.toString())));
          }

          for (var rain in cc.data.rainData) {
            // String date = rain.deviceDate.toIso8601String().split('T')[0];
            String date = rain.deviceDate.toString();
            rainfall.add(
                ChartData(date.toString(), double.parse(rain.rain.toString())));
            cumulativeRainfall.add(ChartData(
                date.toString(), double.parse(rain.cumulativeRain.toString())));
          }

          for (var wind in cc.data.windspeedData) {
            String date = wind.deviceDate.toString();
            maxWindSpeed.add(ChartData(
                date.toString(), double.parse(wind.maxWindSpeed.toString())));
            // averageWindSpeed.add(ChartData(
            //     date.toString(), double.parse(wind.averageWindSpeed)));
          }

          for (var atm in cc.data.atmPresData) {
            String date = atm.deviceDate.toString();
            // averageAtmPres.add(
            //     ChartData(date.toString(), double.parse(atm.averageAtmPres)));
            // averageSolarRadiation.add(ChartData(
            //     date.toString(), double.parse(atm.averageSolarRadiation)));
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
            isLoading = false;
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

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}
