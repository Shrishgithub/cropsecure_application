import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBlock;

  // Sample data for demonstration
  List<String> _states = ['State 1', 'State 2', 'State 3'];
  List<String> _districts = ['District 1', 'District 2', 'District 3'];
  List<String> _blocks = ['Block 1', 'Block 2', 'Block 3'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return DropdownButtonFormField(
                value: _selectedState,
                hint: Text('Select State'),
                items: _states.map((String state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedState = value!;
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return DropdownButtonFormField(
                value: _selectedDistrict,
                hint: Text('Select District'),
                items: _districts.map((String district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value!;
                    state.didChange(value);
                  });
                },
              );
            },
          ),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return DropdownButtonFormField(
                value: _selectedBlock,
                hint: Text('Select Block'),
                items: _blocks.map((String block) {
                  return DropdownMenuItem(
                    value: block,
                    child: Text(block),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBlock = value!;
                    state.didChange(value);
                  });
                },
              );
            },
          ),
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
            Navigator.of(context).pop();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
