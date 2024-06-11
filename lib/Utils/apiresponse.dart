import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cropsecure_application/Utils/appcontroller.dart';
import 'package:http/http.dart' as http;

class APIResponse {
  static APIResponse data = APIResponse();

  /*POST API REQUEST*/
  dynamic postApiRequest(
      String url, Map payload, Map<String, String> header) async {
    /*LOG MESSAGE*/
    log(url, name: 'URL POST');
    log(jsonEncode(payload).toString(), name: 'Payload');
    log(jsonEncode(header).toString(), name: 'Header');
    log(header.toString(), name: 'Header');
    try {
      /*API REQUEST*/
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(payload), headers: header);
      // log('Data Received: Status Code ${response.statusCode}, Content Length:${response.contentLength},body:${response.body},  Reponse: ',
      //     name: 'ApiRequest/PostApiRequest');
      /*CHECK STATUS CODE*/
      if (response.statusCode == 200) {
        return response.body.toString();
      } else if (response.statusCode == 401) {
        // muOnLogout();
        return '401';
      }
    } on SocketException catch (ex) {
      logError('ApiRequest/PostApiRequest', '$ex');
      // toastMsg(muSetText('ServerError', 'Server Error'));
    } on http.ClientException catch (ex) {
      logError('ApiRequest/PostApiRequest', '$ex');
      // toastMsg(muSetText('network_not_available', 'network_not_available'));
    } catch (ex) {
      log('ApiRequest/PostApiRequest', name: '$ex');
    }
    return 'NoData';
  }
}
