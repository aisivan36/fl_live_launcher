import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_state.dart';

final modeProvider = StateProvider<DisplayMode>((ref) => DisplayMode.grid);

enum DisplayMode {
  grid,
  list,
}

class ShowHideAppBar extends ConsumerWidget {
  const ShowHideAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider.state);
    AsyncValue<List<Application>> appsInfo = ref.watch(appsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            snap: true,
            title: const Text('RiverPod Launcher'),
            expandedHeight: 20,
            floating: true,
            actions: [
              IconButton(
                icon: Icon(mode.state == DisplayMode.grid
                    ? Icons.list
                    : Icons.grid_on),
                onPressed: () {
                  mode.state = mode.state == DisplayMode.grid
                      ? DisplayMode.list
                      : DisplayMode.grid;
                },
              ),
            ],
          ),
          mode.state == DisplayMode.list
              ? appsInfo.whenOrNull(
                  data: (List<Application> apps) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        ApplicationWithIcon app =
                            apps[index] as ApplicationWithIcon;
                        return ListTile(
                          leading: Image.memory(
                            app.icon,
                            width: 30,
                          ),
                          title: Text(app.appName),
                          onTap: () => DeviceApps.openApp(app.packageName),
                        );
                      },
                      childCount: apps.length,
                    ),
                  ),
                  loading: () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const CircularProgressIndicator(),
                    ),
                  ),
                )!
              : const GridViewPage(),
        ],
      ),
    );
  }
}

class GridViewPage extends ConsumerWidget {
  const GridViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Application>> appsInfo = ref.watch(appsProvider);

    return appsInfo.whenOrNull(
      data: (List<Application> apps) => SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 8.0,
            mainAxisExtent: 90),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            ApplicationWithIcon app = apps[index] as ApplicationWithIcon;
            return InkWell(
              onTap: () => DeviceApps.openApp(app.packageName),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9.0),
                    child: Image.memory(
                      app.icon,
                      fit: BoxFit.contain,
                      width: 40,
                    ),
                  ),
                  Text(
                    app.appName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 9),
                  )
                ],
              ),
            );
          },
          childCount: apps.length,
        ),
      ),
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const CircularProgressIndicator(),
        ),
      ),
    )!;
  }
}
