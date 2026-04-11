import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

enum AppPermissionStatus { unknown, granted, denied, permanentlyDenied }

class PermissionState {
  final AppPermissionStatus location;
  final AppPermissionStatus camera;
  final AppPermissionStatus notification;

  const PermissionState({
    this.location = AppPermissionStatus.unknown,
    this.camera = AppPermissionStatus.unknown,
    this.notification = AppPermissionStatus.unknown,
  });

  PermissionState copyWith({
    AppPermissionStatus? location,
    AppPermissionStatus? camera,
    AppPermissionStatus? notification,
  }) {
    return PermissionState(
      location: location ?? this.location,
      camera: camera ?? this.camera,
      notification: notification ?? this.notification,
    );
  }
}

class PermissionNotifier extends StateNotifier<PermissionState> {
  PermissionNotifier() : super(const PermissionState()) {
    _checkAll();
  }

  Future<void> _checkAll() async {
    final loc = await ph.Permission.location.status;
    final cam = await ph.Permission.camera.status;
    final notif = await ph.Permission.notification.status;

    state = state.copyWith(
      location: _mapStatus(loc),
      camera: _mapStatus(cam),
      notification: _mapStatus(notif),
    );
  }

  AppPermissionStatus _mapStatus(ph.PermissionStatus s) {
    switch (s) {
      case ph.PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case ph.PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case ph.PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      default:
        return AppPermissionStatus.unknown;
    }
  }

  Future<bool> requestLocation() async {
    final result = await ph.Permission.location.request();
    final granted = result.isGranted || result.isLimited;
    state = state.copyWith(
      location: granted
          ? AppPermissionStatus.granted
          : AppPermissionStatus.denied,
    );
    return granted;
  }

  Future<bool> requestCamera() async {
    final result = await ph.Permission.camera.request();
    final granted = result.isGranted || result.isLimited;
    state = state.copyWith(
      camera: granted
          ? AppPermissionStatus.granted
          : AppPermissionStatus.denied,
    );
    return granted;
  }

  Future<bool> requestNotification() async {
    final result = await ph.Permission.notification.request();
    final granted = result.isGranted || result.isLimited;
    state = state.copyWith(
      notification: granted
          ? AppPermissionStatus.granted
          : AppPermissionStatus.denied,
    );
    return granted;
  }
}

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
      return PermissionNotifier();
    });

final locationGrantedProvider = Provider<bool>((ref) {
  return ref.watch(permissionProvider).location == AppPermissionStatus.granted;
});
