//Code for Multiple Select DropDown

import 'dart:async';
import 'dart:convert';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:cropsecure_application/Database/db.dart';
import 'package:cropsecure_application/Database/sqlquery.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  List<String> _selectedDistricts = [];
  List<String> _selectedBlocks = [];

  // Data lists for dropdowns
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _blocks = [];

  // Map to store state names and their corresponding IDs
  Map<String, String> _stateIdMap = {};
  Map<String, String> _districtIdMap = {};
  Map<String, String> _blockIdMap = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Location'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
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
              Container(
                height: 5,
              ),
              _buildMultiSelectFormField(
                  'Select District', _selectedDistricts, _districts, (values) {
                setState(() {
                  _selectedDistricts = values;
                  // When districts are selected, fetch and set the corresponding blocks
                  _getBlocksForDistricts(values);
                });
              }),
              Container(
                height: 5,
              ),
              _buildMultiSelectFormField(
                  'Select Block', _selectedBlocks, _blocks, (values) {
                setState(() {
                  _selectedBlocks = values;
                });
              }),
            ],
          ),
        ),
      ),
      insetPadding: const EdgeInsets.all(10),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(10.0))),

      // content:
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            // Do something with the selected values
            print(_stateIdMap[_selectedState]);
            print('Selected State: $_selectedState');
            print('Selected Districts: $_selectedDistricts');
            print('Selected Blocks: $_selectedBlocks');
            // String UserId = await SharePref.shred.getString('user_id');

            Map<String, Object?> selectedValues = await _selectedValues();
            // getLocationCount();
            Navigator.of(context).pop(selectedValues);
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
        return InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: value,
              hint: Text(hint),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration.collapsed(hintText: ''),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMultiSelectFormField(String hint, List<String> selectedValues,
      List<String> items, ValueChanged<List<String>> onChanged) {
    return MultiSelectDialogField(
      items: items.map((item) => MultiSelectItem<String>(item, item)).toList(),
      title: Text(hint),
      selectedColor: Colors.blue,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      buttonIcon: Icon(Icons.arrow_drop_down),
      buttonText: Text(
        hint,
        style: TextStyle(fontSize: 16),
      ),
      onConfirm: onChanged,
      initialValue: selectedValues,
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
        _selectedDistricts = []; // Reset selected districts
        _blocks = []; // Clear blocks when districts change
      });

      // Log the fetched data for debugging
      logInfo('District List for State $stateId', result.toString());
    } catch (e) {
      logError('Error fetching district data', e.toString());
    }
  }

  Future<void> _getBlocksForDistricts(List<String> selectedDistricts) async {
    try {
      // Query to get blocks for the selected districts
      String blockQuery =
          'SELECT * FROM ${SqlQuery.inst.Level3LocationTable} WHERE Level2Id IN (${selectedDistricts.map((e) => '?').join(',')})';
      logSuccess('BlockQuery', blockQuery);

      // Fetch the data from the database
      List result = await DB.inst.select(
          blockQuery,
          selectedDistricts
              .map((district) => _districtIdMap[district])
              .toList());

      // Log the fetched data for debugging
      logSuccess('Block Data', result.toString());

      // Map the results to a list of block names
      _blocks = [];
      _blockIdMap = {};
      result.forEach((row) {
        String name = row['Level3Name'].toString();
        String id = row['Level3Id'].toString();
        _blocks.add(name);
        _blockIdMap[name] = id;
      });

      // Update the blocks list
      setState(() {
        _selectedBlocks = []; // Reset selected blocks
      });

      // Log the fetched data for debugging
      logInfo('Block List for Districts $selectedDistricts', result.toString());
    } catch (e) {
      logError('Error fetching block data', e.toString());
    }
  }

  Future<Map<String, Object?>> _selectedValues() async {
    try {
      String userId = await SharePref.shred.getString('user_id');
      final selectedValues = {
        "level1_id": _stateIdMap[_selectedState],
        "level2_id": _selectedDistricts
            .map((district) => _districtIdMap[district])
            .toList(),
        if (_selectedDistricts.length < 4)
          "level3_id":
              _selectedBlocks.map((block) => _blockIdMap[block]).toList(),
        "userId": userId
      };

      logInfo("Selected Values", selectedValues.toString());
      return selectedValues;
    } catch (e) {
      logError("Error in _selectedValues", e.toString());
      return {};
    }
  }
}

//Code for Single Select DropDown

// import 'dart:async';
// import 'dart:convert';
// import 'package:cropsecure_application/Utils/sharedpref.dart';
// import 'package:flutter/material.dart';
// import 'package:cropsecure_application/Database/db.dart';
// import 'package:cropsecure_application/Database/sqlquery.dart';
// import 'package:cropsecure_application/Utils/appcontroller.dart';

// class MyDialog extends StatefulWidget {
//   @override
//   _MyDialogState createState() => _MyDialogState();
// }

// class _MyDialogState extends State<MyDialog> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 500), _getStateData);
//   }

//   String? _selectedState;
//   String? _selectedDistrict;
//   String? _selectedBlock;

//   // Data lists for dropdowns
//   List<String> _states = [];
//   List<String> _districts = [];
//   List<String> _blocks = [];

//   // Map to store state names and their corresponding IDs
//   Map<String, String> _stateIdMap = {};
//   Map<String, String> _districtIdMap = {};
//   Map<String, String> _blockIdMap = {};

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Select Location'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           _buildDropdownFormField('Select State', _selectedState, _states,
//               (value) {
//             setState(() {
//               _selectedState = value;
//               // When a state is selected, fetch and set the corresponding districts
//               _getDistrictsForState(
//                   _stateIdMap[value!]!); // Retrieve state ID from map
//             });
//           }),
//           _buildDropdownFormField(
//               'Select District', _selectedDistrict, _districts, (value) {
//             setState(() {
//               _selectedDistrict = value;
//               // When a district is selected, fetch and set the corresponding blocks
//               _getBlocksForDistrict(
//                   _districtIdMap[value!]!); // Retrieve district ID from map
//             });
//           }),
//           _buildDropdownFormField('Select Block', _selectedBlock, _blocks,
//               (value) {
//             setState(() {
//               _selectedBlock = value;
//             });
//           }),
//         ],
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//         TextButton(
//           onPressed: () async {
//             // Do something with the selected values
//             print(_stateIdMap[_selectedState]);
//             print('Selected State: $_selectedState');
//             print('Selected District: $_selectedDistrict');
//             print('Selected Block: $_selectedBlock');
//             // String UserId = await SharePref.shred.getString('user_id');

//             Map<String, Object?> selectedValues = await _selectedValues();
//             // getLocationCount();
//             Navigator.of(context).pop(selectedValues);
//           },
//           child: Text('Submit'),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdownFormField(String hint, String? value, List<String> items,
//       ValueChanged<String?> onChanged) {
//     return FormField<String>(
//       builder: (FormFieldState<String> state) {
//         return DropdownButtonFormField(
//           value: value,
//           hint: Text(hint),
//           items: items.map((String item) {
//             return DropdownMenuItem(
//               value: item,
//               child: Text(item),
//             );
//           }).toList(),
//           onChanged: onChanged,
//         );
//       },
//     );
//   }

//   Future<void> _getStateData() async {
//     try {
//       String stateQuery = 'SELECT * FROM ${SqlQuery.inst.Level1LocationTable}';
//       logSuccess('StateQuery', stateQuery);

//       // Fetch the data from the database
//       List result = await DB.inst.select(stateQuery, []);

//       // Map the results to a list of state names and their corresponding IDs
//       result.forEach((row) {
//         String name = row['name'].toString();
//         String id = row['id'].toString();
//         _states.add(name);
//         _stateIdMap[name] = id;
//       });

//       // Log the fetched data for debugging
//       logInfo('State List', result.toString());

//       // Update the state with the fetched state names
//       setState(() {});

//       // Fetch and set the districts for the first state in the list
//       if (_states.isNotEmpty) {
//         _getDistrictsForState(_stateIdMap[_states.first]!);
//       }
//     } catch (e) {
//       logError('Error fetching state data', e.toString());
//     }
//   }

//   Future<void> _getDistrictsForState(String stateId) async {
//     try {
//       // Query to get districts for the selected state
//       String districtQuery =
//           'SELECT * FROM ${SqlQuery.inst.Level2LocationTable} WHERE Level1Id = ?';
//       logSuccess('DistrictQuery', districtQuery);

//       // Fetch the data from the database
//       List result = await DB.inst.select(districtQuery, [stateId]);

//       // Log the fetched data for debugging
//       logSuccess('District Data', result.toString());

//       // Map the results to a list of district names and their corresponding IDs
//       _districts = [];
//       _districtIdMap = {};
//       result.forEach((row) {
//         String name = row['Level2Name'].toString();
//         String id = row['Level2Id'].toString();
//         _districts.add(name);
//         _districtIdMap[name] = id;
//       });

//       // Update the districts list
//       setState(() {
//         _selectedDistrict = null; // Reset selected district
//         _blocks = []; // Clear blocks when district changes
//       });

//       // Log the fetched data for debugging
//       logInfo('District List for State $stateId', result.toString());
//     } catch (e) {
//       logError('Error fetching district data', e.toString());
//     }
//   }

//   Future<void> _getBlocksForDistrict(String districtId) async {
//     try {
//       // Query to get blocks for the selected district
//       String blockQuery =
//           'SELECT * FROM ${SqlQuery.inst.Level3LocationTable} WHERE Level2Id = ?';
//       logSuccess('BlockQuery', blockQuery);

//       // Fetch the data from the database
//       List result = await DB.inst.select(blockQuery, [districtId]);

//       // Log the fetched data for debugging
//       logSuccess('Block Data', result.toString());

//       // Map the results to a list of block names
//       // _blocks = result.map((row) => row['Level3Name'].toString()).toList();

//       _blocks = [];
//       _blockIdMap = {};
//       result.forEach(
//         (row) {
//           String name = row['Level3Name'].toString();
//           String id = row['Level3Id'].toString();
//           _blocks.add(name);
//           _blockIdMap[name] = id;
//         },
//       );

//       // Update the blocks list
//       setState(() {
//         _selectedBlock = null; // Reset selected block
//       });

//       // Log the fetched data for debugging
//       logInfo('Block List for District $districtId', result.toString());
//     } catch (e) {
//       logError('Error fetching block data', e.toString());
//     }
//   }

//   Future<Map<String, Object?>> _selectedValues() async {
//     try {
//       String userId = await SharePref.shred.getString('user_id');
//       final selectedValues = {
//         "level1_id": _stateIdMap[
//             _selectedState], //jsonEncode(_stateIdMap[_selectedState]),
//         "level2_id": [
//           _districtIdMap[_selectedDistrict]
//         ], //jsonEncode([_districtIdMap[_selectedDistrict]]),
//         "level3_id": [
//           _blockIdMap[_selectedBlock]
//         ], //jsonEncode(_blockIdMap[_selectedBlock]),
//         "userId": userId
//       };

//       logInfo("Selected Values", selectedValues.toString());
//       return selectedValues;
//     } catch (e) {
//       logError("Error in _selectedValues", e.toString());
//       return {};
//     }
//   }
// }
