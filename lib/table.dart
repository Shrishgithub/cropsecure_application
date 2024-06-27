import 'package:cropsecure_application/Model/locationcount.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/listdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartTable extends StatelessWidget {
  List<ParamData>? paramData;
  ChartTable({required this.paramData});
  // const ChartTable({super.key});33

  @override
  Widget build(BuildContext context) {
    logError('checkData1', (paramData == null).toString());
    return Container(
      color: Color.fromARGB(255, 230, 213, 187),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Title(
                color: Colors.black,
                child: Text(
                  'AWS Location Parameter',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ), //color: Color.fromARGB(255, 129, 122, 122)
                )),
          ),
          Container(
            color: Color.fromARGB(255, 239, 210, 166),
            child: DataTable(columns: [
              DataColumn(
                  label: Text(
                'Parameter',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'Value',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ], rows: [
              DataRow(cells: [
                DataCell(Text(
                  'MaxRainFall (mm)',
                )),
                DataCell(Text(paramData!.first.maxRain.datavalue
                    .toString())), ////widget.paramData.maxRain.datavalue.toString()
                DataCell(Text(
                  paramData!.first.maxRain.id.toString(),
                  style: TextStyle(color: Color.fromARGB(255, 231, 3, 3)),
                )),
              ]),
              DataRow(cells: [
                DataCell(Text('MaxTemp (℃)')),
                DataCell(Text(paramData!.first.maxTemp.datavalue.toString())),
                DataCell(Text(
                  paramData!.first.maxTemp.id.toString(),
                  style: TextStyle(color: Color.fromARGB(255, 231, 3, 3)),
                )),
              ]),
              DataRow(cells: [
                DataCell(Text('MinTemp (℃) ')),
                DataCell(Text(paramData!.first.minTemp.datavalue.toString())),
                DataCell(Text(
                  paramData!.first.minTemp.id.toString(),
                  style: TextStyle(color: Color.fromARGB(255, 30, 181, 35)),
                )),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}
