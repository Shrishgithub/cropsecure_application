import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cropsecure_application/Database/db.dart';
import 'package:cropsecure_application/Database/sqlquery.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), _getStateData);
  }

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBlock;

  // Data lists for dropdowns
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _blocks = [];

  // Map to store state names and their corresponding IDs
  Map<String, String> _stateIdMap = {};
  Map<String, String> _districtIdMap = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildDropdownFormField('Select State', _selectedState, _states,
              (value) {
            setState(() {
              _selectedState = value;
              // When a state is selected, fetch and set the corresponding districts
              _getDistrictsForState(
                  _stateIdMap[value!]!); // Retrieve state ID from map
            });
          }),
          _buildDropdownFormField(
              'Select District', _selectedDistrict, _districts, (value) {
            setState(() {
              _selectedDistrict = value;
              // When a district is selected, fetch and set the corresponding blocks
              _getBlocksForDistrict(
                  _districtIdMap[value!]!); // Retrieve district ID from map
            });
          }),
          _buildDropdownFormField('Select Block', _selectedBlock, _blocks,
              (value) {
            setState(() {
              _selectedBlock = value;
            });
          }),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            // Do something with the selected values
            print('Selected State: $_selectedState');
            print('Selected District: $_selectedDistrict');
            print('Selected Block: $_selectedBlock');
            // getLocationCount();
            Navigator.of(context).pop();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildDropdownFormField(String hint, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return DropdownButtonFormField(
          value: value,
          hint: Text(hint),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        );
      },
    );
  }

  Future<void> _getStateData() async {
    try {
      String stateQuery = 'SELECT * FROM ${SqlQuery.inst.Level1LocationTable}';
      logSuccess('StateQuery', stateQuery);

      // Fetch the data from the database
      List result = await DB.inst.select(stateQuery, []);

      // Map the results to a list of state names and their corresponding IDs
      result.forEach((row) {
        String name = row['name'].toString();
        String id = row['id'].toString();
        _states.add(name);
        _stateIdMap[name] = id;
      });

      // Log the fetched data for debugging
      logInfo('State List', result.toString());

      // Update the state with the fetched state names
      setState(() {});

      // Fetch and set the districts for the first state in the list
      if (_states.isNotEmpty) {
        _getDistrictsForState(_stateIdMap[_states.first]!);
      }
    } catch (e) {
      logError('Error fetching state data', e.toString());
    }
  }

  Future<void> _getDistrictsForState(String stateId) async {
    try {
      // Query to get districts for the selected state
      String districtQuery =
          'SELECT * FROM ${SqlQuery.inst.Level2LocationTable} WHERE Level1Id = ?';
      logSuccess('DistrictQuery', districtQuery);

      // Fetch the data from the database
      List result = await DB.inst.select(districtQuery, [stateId]);

      // Log the fetched data for debugging
      logSuccess('District Data', result.toString());

      // Map the results to a list of district names and their corresponding IDs
      _districts = [];
      _districtIdMap = {};
      result.forEach((row) {
        String name = row['Level2Name'].toString();
        String id = row['Level2Id'].toString();
        _districts.add(name);
        _districtIdMap[name] = id;
      });

      // Update the districts list
      setState(() {
        _selectedDistrict = null; // Reset selected district
        _blocks = []; // Clear blocks when district changes
      });

      // Log the fetched data for debugging
      logInfo('District List for State $stateId', result.toString());
    } catch (e) {
      logError('Error fetching district data', e.toString());
    }
  }

  Future<void> _getBlocksForDistrict(String districtId) async {
    try {
      // Query to get blocks for the selected district
      String blockQuery =
          'SELECT * FROM ${SqlQuery.inst.Level3LocationTable} WHERE Level2Id = ?';
      logSuccess('BlockQuery', blockQuery);

      // Fetch the data from the database
      List result = await DB.inst.select(blockQuery, [districtId]);

      // Log the fetched data for debugging
      logSuccess('Block Data', result.toString());

      // Map the results to a list of block names
      _blocks = result.map((row) => row['Level3Name'].toString()).toList();

      // Update the blocks list
      setState(() {
        _selectedBlock = null; // Reset selected block
      });

      // Log the fetched data for debugging
      logInfo('Block List for District $districtId', result.toString());
    } catch (e) {
      logError('Error fetching block data', e.toString());
    }
  }
}
