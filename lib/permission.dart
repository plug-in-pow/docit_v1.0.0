import 'package:permission_handler/permission_handler.dart';

final PermissionHandler _permissionHandler = PermissionHandler();

askpermission() async {
  await PermissionHandler().requestPermissions([PermissionGroup.storage]);
}

Future<bool> checkstatus() async {
  var permissionStatus =
      await _permissionHandler.checkPermissionStatus(PermissionGroup.storage);
  if (permissionStatus == PermissionStatus.granted) {
    return true;
  } else {
    return false;
  }
}
