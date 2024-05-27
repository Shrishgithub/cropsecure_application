import 'package:flutter/material.dart';

class LocationListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location List'),
        ),
        body: LocationListTable(),
      ),
    );
  }
}

class LocationListTable extends StatelessWidget {
  final List<Map<String, String>> locations = [
    {
      'State': 'Uttar Pradesh',
      'District': 'Basti',
      'Block': 'Dubaulia',
      'Id': '21538',
      'Name': 'Dubauliya',
      'Latitude': '26.7003651',
      'Longitude': '82.4950377'
    },
    {
      'State': 'Uttar Pradesh',
      'District': 'Basti',
      'Block': 'Harraiya',
      'Id': '21552',
      'Name': 'Harraiya Ghat',
      'Latitude': '26.8056477',
      'Longitude': '82.4619967'
    },
    {
      'State': 'Uttar Pradesh',
      'District': 'Basti',
      'Block': 'Vikram Jot',
      'Id': '65479',
      'Name': 'Malauli Gosai',
      'Latitude': '26.7768775',
      'Longitude': '82.3223084'
    },
    {
      'State': 'Uttar Pradesh',
      'District': 'Basti',
      'Block': 'Vikram Jot',
      'Id': '65480',
      'Name': 'Sandalpura',
      'Latitude': '26.7943806',
      'Longitude': '82.2915299'
    },
    {
      'State': 'Uttar Pradesh',
      'District': 'Basti',
      'Block': 'Harraiya',
      'Id': '65482',
      'Name': 'Amari',
      'Latitude': '26.8266726',
      'Longitude': '82.4130373'
    },
    {
      'State': 'Uttar Pradesh',
      'District': 'Basti',
      'Block': 'Dubaulia',
      'Id': '65484',
      'Name': 'Bharukahawa',
      'Latitude': '26.7034111',
      'Longitude': '82.5407282'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('State')),
          DataColumn(label: Text('District')),
          DataColumn(label: Text('Block')),
          DataColumn(label: Text('Id')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Latitude')),
          DataColumn(label: Text('Longitude')),
        ],
        rows: locations.map((location) {
          return DataRow(cells: [
            DataCell(Text(location['State']!)),
            DataCell(Text(location['District']!)),
            DataCell(Text(location['Block']!)),
            DataCell(Text(location['Id']!)),
            DataCell(Text(location['Name']!)),
            DataCell(Text(location['Latitude']!)),
            DataCell(Text(location['Longitude']!)),
          ]);
        }).toList(),
      ),
    );
  }
}
