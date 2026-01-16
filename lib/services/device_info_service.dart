// ignore_for_file: dead_code, unused_element

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Returns the device name or 'unknown' if it cannot be determined.
  static Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        final manufacturer = info.manufacturer;
        final model = info.model;
        return ('$manufacturer $model').trim().isNotEmpty
            ? ('$manufacturer $model').trim()
            : 'Android device';
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return info.name;
      } else if (Platform.isWindows) {
        final info = await _deviceInfo.windowsInfo;
        return info.computerName;
      } else if (Platform.isMacOS) {
        final info = await _deviceInfo.macOsInfo;
        return info.model;
      } else if (Platform.isLinux) {
        final info = await _deviceInfo.linuxInfo;
        return info.prettyName;
      } else {
        return 'unknown';
      }
    } catch (_) {
      return 'unknown';
    }
  }
}
