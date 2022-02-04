import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launcher_riverpod/app_state.dart';

final modeProvider = StateProvider<DisplayMode>((ref) => DisplayMode.grid);

enum DisplayMode {
  grid,
  list,
}

class AppsPage extends StatefulWidget {
  const AppsPage({Key? key}) : super(key: key);

  @override
  _AppsPageState createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, ref, child) {
        final appsInfo = ref.watch(appsProvider);
        final mode = ref.watch(modeProvider.state);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('RiverPod Launcher'),
            elevation: 1,
            backgroundColor: Colors.transparent,
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
          body: appsInfo.when(
            data: (List<Application> apps) => mode.state == DisplayMode.list
                ? ListView.builder(
                    itemCount: apps.length,
                    itemBuilder: (BuildContext context, int index) {
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
                    })
                : GridView(
                    padding: const EdgeInsets.fromLTRB(
                        16.0, kToolbarHeight + 16.0, 16.0, 16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    children: [
                      ...apps.map((e) => AppGridItem(
                          applicationWithIcon: e as ApplicationWithIcon))
                    ],
                  ),
            error: (e, s) => const SizedBox(),
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AppGridItem extends StatelessWidget {
  const AppGridItem({Key? key, required this.applicationWithIcon})
      : super(key: key);

  final ApplicationWithIcon applicationWithIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => DeviceApps.openApp(applicationWithIcon.packageName),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Image.memory(
              applicationWithIcon.icon,
              fit: BoxFit.contain,
              width: 40,
            ),
          ),
          Text(
            applicationWithIcon.appName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 9),
          )
        ],
      ),
    );
  }
}
