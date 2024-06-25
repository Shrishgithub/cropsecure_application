import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartTable extends StatefulWidget {
  const ChartTable({super.key});

  @override
  State<ChartTable> createState() => _ChartTableState();
}

class _ChartTableState extends State<ChartTable> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Title(
                color: Colors.black,
                child: Text(
                  'Location Data',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
          ),
          DataTable(columns: [
            DataColumn(label: Text('Parameter')),
            DataColumn(label: Text('Value')),
            DataColumn(label: Text('Location')),
          ], rows: [
            DataRow(cells: [
              DataCell(Text('MaxRainFall (mm)')),
              DataCell(Text('0')),
              DataCell(Text('Sandalpura (65480)')),
            ]),
            DataRow(cells: [
              DataCell(Text('MaxTemp (℃)')),
              DataCell(Text('26.80')),
              DataCell(Text('Sandalpura (65480)')),
            ]),
            DataRow(cells: [
              DataCell(Text('MinTemp (℃')),
              DataCell(Text('12.55')),
              DataCell(Text('Malauli Gosai (65479)')),
            ]),
          ]),
        ],
      ),
    );
  }
}
