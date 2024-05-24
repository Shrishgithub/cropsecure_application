import 'dart:convert';
import 'dart:developer';

import 'package:cropsecure_application/Utils/api_payload.dart';
import 'package:cropsecure_application/Utils/apiresponse.dart';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:cropsecure_application/Utils/constant.dart';
import 'package:cropsecure_application/Utils/sharedpref.dart';
import 'package:cropsecure_application/Utils/spinkit.dart';
import 'package:cropsecure_application/listdata.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _groupIdController = TextEditingController();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 175, 199, 234),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.green,
          ],
        )),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/wrms_logo.png',
                height: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 40, right: 40),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                        height: 80,
                        child: Center(
                            child: Text(
                          "CROPSECURE",
                          style: TextStyle(fontSize: 30),
                        ))),
                    const SizedBox(
                      height: 50,
                    ),
                    loginData(
                        _groupIdController, "Group ID", false, Icons.group),
                    loginData(_userIdController, "User ID", false,
                        Icons.verified_user),
                    loginData(_passwordController, "Password", true,
                        Icons.remove_red_eye),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue,
                      ),
                      child: ElevatedButton(
                        onPressed: () => onTapLogin(),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Makes button transparent
                          shadowColor: Colors.transparent, // Removes shadow
                          elevation: 0, // Removes default elevation
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget loginData(TextEditingController groupIdController, String name,
      bool obscureText, IconData iconData) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
      child: TextFormField(
        controller: groupIdController,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: name,
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            iconData,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  // Future<void> onTapLogin() async {
  //   var data = await APIResponse.data.postApiRequest(
  //       Constant.LOG_IN,
  //       ApiPayload.inst.login(_groupIdController.text.toString(),
  //           _userIdController.text.toString(), _passwordController.text),
  //       {
  //         'Content-Type': 'application/json',
  //       });

  //   if (data != '401' && data != 'NoData') {
  //     data = jsonDecode(data);
  //     if (data['status'] == 'success') {
  //       log(data['loginRes'].toString(), name: 'data');
  //       log(data['loginRes'][0]['token'].toString(), name: 'data');
  //       SharePref.shred.setBool('islogin', true);
  //       SharePref.shred.setString('token', data['loginRes'][0]['token']);

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => ListData()),
  //       );
  //     }
  //   }
  //   print(data.toString());
  //   // login(_groupIdController.text, _userIdController.text,
  //   //     _passwordController.text);
  // }
  Future<void> onTapLogin() async {
    // Show loading indicator
    // FocusManager.instance.primaryFocus?.unfocus();
    // showDialog(
    //   context: context,
    //   barrierDismissible: false, // Prevent user from dismissing the dialog
    //   builder: (BuildContext context) {
    //     return const Center(
    //       child: CircularProgressIndicator(
    //         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    //       ),
    //     );
    //   },
    // );

    try {
      dialogLoader(context, 'Loading...');
      var data = await APIResponse.data.postApiRequest(
        Constant.LOG_IN,
        ApiPayload.inst.login(
          _groupIdController.text.toString(),
          _userIdController.text.toString(),
          _passwordController.text,
        ),
        {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $token',
        },
      );

      // Close loading indicator
      // Navigator.pop(context);

      if (data != '401' && data != 'NoData') {
        data = jsonDecode(data);
        if (data['status'] == 'success') {
          log(data['loginRes'].toString(), name: 'data');
          log(data['loginRes'][0]['token'].toString(), name: 'data');
          SharePref.shred.setBool('islogin', true);
          SharePref.shred.setString('token', data['loginRes'][0]['token']);
          String token = await SharePref.shred.getString('token');
          print('$token');
          SharePref.shred.setString('user_id', data['loginRes'][0]['user_id']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListData()),
          );
          // dialogClose(context);
        } else {
          dialogClose(context);
          toastMsg('Invalid Credential, Please try again!!');
        }
      }

      print(data.toString());
    } catch (e) {
      // Handle any errors
      print('Error: $e');
      // Close loading indicator
      Navigator.pop(context);
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }
}
