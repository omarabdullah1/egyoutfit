// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({Key key}) : super(key: key);
//
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//    PageController controller;
//    int indexPage;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = PageController(initialPage: 1);
//     indexPage = controller.initialPage;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("osm"),
//       ),
//       body: PageView(
//         children: const <Widget>[
//           Center(
//             child: Text("page n1"),
//           ),
//           SimpleOSM(),
//         ],
//         controller: controller,
//         onPageChanged: (p) {
//           setState(() {
//             indexPage = p;
//           });
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: indexPage,
//         onTap: (p) {
//           controller.animateToPage(p,
//               duration: const Duration(milliseconds: 500), curve: Curves.linear);
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.info),
//             label: "information",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.contacts),
//             label: "contact",
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SimpleOSM extends StatefulWidget {
//   const SimpleOSM({Key key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => SimpleOSMState();
// }
//
// class SimpleOSMState extends State<SimpleOSM>
//     with AutomaticKeepAliveClientMixin {
//   MapController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = MapController(
//       initMapWithUserPosition: true,
//     );
//   }
//
//   @override
//   @mustCallSuper
//   Widget build(BuildContext context) {
//     super.build(context);
//     return OSMFlutter(
//       controller: controller,
//       markerOption: MarkerOption(
//         defaultMarker: const MarkerIcon(
//           icon: Icon(
//             Icons.person_pin_circle,
//             color: Colors.blue,
//             size: 56,
//           ),
//         ),
//       ),
//       trackMyPosition: false,
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }