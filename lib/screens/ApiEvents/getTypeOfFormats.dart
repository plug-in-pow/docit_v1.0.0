import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String url = "https://api.cloudconvert.com/v2/convert/formats";

Future<Map<String, List<String>>> getInputOutputFormatOnGroup(
    String groupName) async {
  Set<String> inputFormat = {};
  List<List<String>> outputFormat = [];
  try {
    http.Response response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    Map<String, dynamic> data = json.decode(response.body);

    for (var i = 0; i < data["data"].length; i++) {
      if (data["data"][i]["meta"]["group"] == groupName) {
        // print(data["data"][i]["output_format"]);
        inputFormat.add(data["data"][i]["output_format"]);
      }
    }
    for (var i = 0; i < inputFormat.length; i++) {
      List<String> temp = [];

      for (var j = 0; j < data["data"].length; j++) {
        if (data["data"][j]["input_format"] == inputFormat.elementAt(i)) {
          temp.add(data["data"][j]["output_format"]);
        }
      }

      outputFormat.add(temp);
    }

    Map<String, List<String>> inputOutputFormat =
        new Map.fromIterables(inputFormat, outputFormat);
    return inputOutputFormat;
  } on SocketException {
    return Future.error("Network Error please connect to internet",
        StackTrace.fromString("Network Failure"));
  } catch (e) {
    return Future.error(
        'Something went wrong please reinstall or restart the app');
  }
}
