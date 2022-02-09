// import 'package:device_apps/device_apps.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:launcher_riverpod/app_state.dart';

// final modeProvider = StateProvider<DisplayMode>((ref) => DisplayMode.grid);

// enum DisplayMode {
//   grid,
//   list,
// }

// class AutoHideAppbar extends ConsumerStatefulWidget {
//   const AutoHideAppbar({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AutoHideAppbarState();
// }

// class _AutoHideAppbarState extends ConsumerState<AutoHideAppbar> {
//   @override
//   void initState() {
//     super.initState();
//     ref.read(scrollController).addListener(() {
//       if (ref.read(scrollController).position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         if (!ref.read(isScrollingDown.notifier).state) {
//           ref.read(isScrollingDown.notifier).state = true;
//           ref.read(showAppbar.state).state = false;
//           setState(() {});
//           print(ref.read(showAppbar.state).state);
//         }
//       }

//       if (ref.read(scrollController).position.userScrollDirection ==
//           ScrollDirection.forward) {
//         if (ref.read(isScrollingDown.notifier).state) {
//           ref.read(isScrollingDown.notifier).state = false;
//           ref.read(showAppbar.state).state = true;
//           setState(() {});
//           print(ref.read(showAppbar.state).state);
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // ref.read(scrollController.state).state.dispose();
//     super.dispose();
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     final mode = ref.watch(modeProvider.state);

//     return Scaffold(
//       key: _scaffoldKey,
//       body: SafeArea(
//         child: Column(
//           children: [
//             AnimatedContainer(
//               height: ref.watch(showAppbar.state).state ? 56.0 : 0.0,
//               duration: const Duration(milliseconds: 200),
//               child: AppBar(
//                 title: const Text('RiverPod Launcher'),
//                 elevation: 1,
//                 backgroundColor: Colors.transparent,
//                 actions: [
//                   IconButton(
//                     icon: Icon(mode.state == DisplayMode.grid
//                         ? Icons.list
//                         : Icons.grid_on),
//                     onPressed: () {
//                       mode.state = mode.state == DisplayMode.grid
//                           ? DisplayMode.list
//                           : DisplayMode.grid;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const Expanded(
//               child: AppsPage(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AppsPage extends ConsumerWidget {
//   const AppsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     AsyncValue<List<Application>> appsInfo = ref.watch(appsProvider);
//     final mode = ref.watch(modeProvider.state);

//     return appsInfo.when(
//       data: (List<Application> apps) => mode.state == DisplayMode.list
//           ? ListView.builder(
//               controller: ref.watch(scrollController),
//               itemCount: apps.length,
//               itemBuilder: (BuildContext context, int index) {
//                 ApplicationWithIcon app = apps[index] as ApplicationWithIcon;

//                 return ListTile(
//                   leading: Image.memory(
//                     app.icon,
//                     width: 30,
//                   ),
//                   title: Text(app.appName),
//                   onTap: () => DeviceApps.openApp(app.packageName),
//                 );
//               })
//           : const AppGridItem(),
//       error: (e, s) => const SizedBox(),
//       loading: () => const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }

// class AppGridItem extends ConsumerWidget {
//   const AppGridItem({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     AsyncValue<List<Application>> appsInfo = ref.watch(appsProvider);

//     return appsInfo.when(
//         error: (error, stackTrace) => SizedBox(
//               child: Text(error.toString()),
//             ),
//         loading: () => const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         data: (List<Application> apps) => GridView(
//               controller: ref.watch(scrollController),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//               ),
//               children: [
//                 ...apps.map(
//                   (valueIconApp) {
//                     ApplicationWithIcon icon =
//                         valueIconApp as ApplicationWithIcon;
//                     return InkWell(
//                       onTap: () => DeviceApps.openApp(valueIconApp.packageName),
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.memory(
//                               icon.icon,
//                               fit: BoxFit.contain,
//                               width: 40,
//                             ),
//                           ),
//                           Text(
//                             valueIconApp.appName,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: const TextStyle(fontSize: 9),
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ));
//   }
// }
