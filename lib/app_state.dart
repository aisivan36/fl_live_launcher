import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appsProvider = FutureProvider<List<Application>>(
    (ref) async => await DeviceApps.getInstalledApplications(
          includeAppIcons: true,
          includeSystemApps: true,
          onlyAppsWithLaunchIntent: true,
        ));

final scrollController = Provider.autoDispose<ScrollController>(
  (ref) {
    ref.maintainState = true;
    return ScrollController();
  },
);

final showAppbar = StateProvider<bool>(
  (ref) => true,
);

class AskingAppBar extends StateNotifier<bool> {
  AskingAppBar() : super(false);
  void showAppbar(bool showVal) {
    state = showVal;
  }

  void isScrollingDown(bool askVal) {
    state = askVal;
  }
}

final askingAppBar = StateNotifierProvider<AskingAppBar, bool>(
  (ref) => AskingAppBar(),
);

final isScrollingDown = StateProvider<bool>(
  (ref) => false,
);
