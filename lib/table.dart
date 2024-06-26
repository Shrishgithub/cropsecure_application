import 'package:cropsecure_application/Model/locationcount.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/listdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartTable extends StatelessWidget {
  ParamData? paramData;
  ChartTable({required this.paramData});
  // const ChartTable({super.key});

  @override
  Widget build(BuildContext context) {
    logError('checkData', (paramData == null).toString());
    return SizedBox(
      child: paramData != null
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Title(
                      color: Colors.black,
                      child: Text(
                        'Location Data',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                ),
                DataTable(columns: [
                  DataColumn(label: Text('Parameter')),
                  DataColumn(label: Text('Value')),
                  DataColumn(label: Text('Location')),
                ], rows: [
                  DataRow(cells: [
                    DataCell(Text('MaxRainFall (mm)')),
                    DataCell(Text(paramData!.maxRain.datavalue
                        .toString())), ////widget.paramData.maxRain.datavalue.toString()
                    DataCell(Text(paramData!.maxRain.id.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('MaxTemp (℃)')),
                    DataCell(Text(paramData!.maxTemp.datavalue.toString())),
                    DataCell(Text(paramData!.maxTemp.id.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('MinTemp (℃')),
                    DataCell(Text(paramData!.minTemp.datavalue.toString())),
                    DataCell(Text(paramData!.minTemp.id.toString())),
                  ]),
                ]),
              ],
            )
          : null,
    );
  }
}
