import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Retourne un nom lisible du device, ou 'unknown' en cas d'erreur.
  static Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        final manufacturer = info.manufacturer ?? '';
        final model = info.model ?? info.device ?? '';
        return ('$manufacturer $model').trim().isNotEmpty ? ('$manufacturer $model').trim() : 'Android device';
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return info.name ?? info.utsname.machine ?? info.model ?? 'iOS device';
      } else if (Platform.isWindows) {
        final info = await _deviceInfo.windowsInfo;
        return info.computerName ?? info.productName ?? 'Windows device';
      } else if (Platform.isMacOS) {
        final info = await _deviceInfo.macOsInfo;
        return info.model ?? info.arch ?? 'macOS device';
      } else if (Platform.isLinux) {
        final info = await _deviceInfo.linuxInfo;
        return info.prettyName ?? info.name ?? 'Linux device';
      } else {
        return 'unknown';
      }
    } catch (_) {
      return 'unknown';
    }
  }
}