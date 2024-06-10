import 'dart:convert';

import 'package:cropsecure_application/Model/chartdetailmodel.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/dateformat.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/rainfalldata.dart';
import 'package:cropsecure_application/temphumidity.dart';
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
    // TODO: implement initState
    super.initState();
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
      body: ListView(
        children: [
          Temprature(
              name: 'Temperature & Humidity',
              dat1: maxTempData,
              dat2: minTempData,
              data3: minMoistureData),
          DataSetUI(
              name: 'Rainfall', data1: rainfallData, data2: cumulativeRainData),
          DataSetUI(
              name: 'WindSpeed',
              data1: maxWindSpeedData,
              data2: avarageWindSpeedData),
          DataSetUI(
              name: 'Atmospheric Pressure',
              data1: maxWindSpeedData,
              data2: avarageWindSpeedData),
          DataSetUI(
              name: 'PmData',
              data1: maxWindSpeedData,
              data2: avarageWindSpeedData),
          DataSetUI(
              name: 'VocNoxData',
              data1: maxWindSpeedData,
              data2: avarageWindSpeedData)
        ],
      ),
    );
  }

  Future<void> getChartData() async {
    String token = await SharePref.shred.getString('token');
    logSuccess('token', token);
    try {
      var data = await APIResponse.data.postApiRequest(Constant.LocationData, {
        "location_id": "6548d6a19e64505b18014b63",
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
            averageWindSpeed.add(ChartData(
                date.toString(), double.parse(wind.averageWindSpeed)));
          }

          for (var atm in cc.data.atmPresData) {
            String date = atm.deviceDate.toString();
            averageAtmPres.add(
                ChartData(date.toString(), double.parse(atm.averageAtmPres)));
            averageSolarRadiation.add(ChartData(
                date.toString(), double.parse(atm.averageSolarRadiation)));
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
