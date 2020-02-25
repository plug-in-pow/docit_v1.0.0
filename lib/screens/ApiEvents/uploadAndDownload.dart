import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:progress_dialog/progress_dialog.dart';

String url = "https://api.cloudconvert.com/v2/jobs";
String token = DotEnv().env['API_TOKEN'];
Map<String, String> headers = {
  'Authorization': 'Bearer $token',
  'Content-type': 'application/json'
};
var dio = Dio();
ProgressDialog pr;

Future<List<String>> createUploadJob(String inputType, String outputType,
    List<String> paths, BuildContext context) async {
  Map<String, dynamic> tempBodyImportTag = {};
  List<String> importList = [];

  for (var i = 1; i <= paths.length; i++) {
    tempBodyImportTag.addAll({
      "import-$i": {"operation": "import/upload"},
    });
    importList.add("import-$i");
  }

  tempBodyImportTag.addAll({
    "task-1": {
      "operation": "convert",
      "input_format": inputType,
      "output_format": outputType,
      "input": importList
    },
    "export-1": {
      "operation": "export/url",
      "input": ["task-1"],
    }
  });

  var body = jsonEncode({"tasks": tempBodyImportTag});

  try {
    Response<Map> response = await dio.post(url,
        options: Options(
          headers: headers,
        ),
        data: body);

    Map<String, dynamic> res = response.data;

    return await uploadFilePost(res, paths);
  } catch (e) {
    if (e is DioError) {
      return Future.error(
          'Oops Something went wrong ! Plz check Internet connection.');
    } else {
      return Future.error(
          'Seems our API broke please reinstall this app or try later!');
    }
  }
}

Future<List<String>> uploadFilePost(
    Map<String, dynamic> res, List<String> paths) async {
  List<String> downloadLinks = [];
  List<Map<String, dynamic>> parameters = [];
  List<String> postUrl = [];

  for (var i = 0; i < paths.length; i++) {
    parameters.add(res["data"]["tasks"][i + 1]["result"]["form"]["parameters"]);
    postUrl.add(res["data"]["tasks"][i + 1]["result"]["form"]["url"]);

    FormData formData = new FormData.fromMap({
      "expires": parameters[i]["expires"],
      "max_file_count": 1,
      "max_file_size": 10000000000,
      "redirect": parameters[i]["redirect"],
      "signature": parameters[i]["signature"],
      "file": await MultipartFile.fromFile(paths[i],
          filename: p.basename(paths[i])),
    });

    try {
      Response postRessponse = await dio.post(postUrl[i],
          options: Options(headers: headers), data: formData);
      if (postRessponse.statusCode == 201) {
        continue;
      } else {
        break;
      }
    } catch (e) {
      return Future.error(
          'Oops Something went wrong ! Plz check Internet connection.');
    }
  }
  try {
    while (true) {
      Response<Map> downloadResponse = await dio.getUri(
          Uri.parse(res["data"]["links"]["self"]),
          options: Options(headers: headers));

      print(downloadResponse.data["data"]["status"]);

      if (downloadResponse.data["data"]["status"] == "waiting" ||
          downloadResponse.data["data"]["status"] == "processing") {
        continue;
      } else if (downloadResponse.data["data"]["status"] == "finished") {
        for (var i = 0; i < paths.length; i++) {
          downloadLinks.add(downloadResponse.data["data"]["tasks"][i]["result"]
              ["files"][0]["url"]);
        }
        break;
      }
    }
    return downloadLinks;
  } catch (e) {
    return e;
  }
}
