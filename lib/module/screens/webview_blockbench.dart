// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:local_assets_server/local_assets_server.dart';
// import 'package:pamobile_verify/tool_upload_community/screens/detail_item_screen.dart';
// import 'package:path/path.dart' as p;
//
// import '../compoment/config_size.dart';
//
// class WebViewBlockBenchPage extends StatefulWidget {
//   final String? status;
//   final Map<String, dynamic> data;
//
//   const WebViewBlockBenchPage({
//     Key? key,
//     this.status,
//     required this.data,
//   }) : super(key: key);
//
//   @override
//   _WebViewBlockBenchPageState createState() => _WebViewBlockBenchPageState();
// }
//
// class _WebViewBlockBenchPageState extends State<WebViewBlockBenchPage> {
//   // final EditDetailCommController editController =
//   // Get.put(EditDetailCommController());
//
//   late LocalAssetsServer server;
//   String? address;
//   int? port;
//
//   late ColorScheme colorScheme;
//
//   int totalProgress = 0;
//
//   late FlutterWebviewPlugin flutterWebViewPlugin;
//
//   Future<void> _initModel() async {
//     final geoJson = widget.data['geoJson'];
//     final texture = widget.data['texture'];
//
//     final data = {
//       'data': [
//         {
//           "file_name": "model.json",
//           "type": "model",
//           "data": geoJson,
//         },
//         {
//           "file_name": "data.png",
//           "type": "texture",
//           "data": base64Encode(texture),
//         },
//       ]
//     };
//
//     await flutterWebViewPlugin
//         .evalJavascript("window.loadModelFromApp(${jsonEncode(data)})");
//   }
//
//   bool enableReload = true;
//
//   late TextEditingController nameModelController;
//   late TextEditingController authorModelController;
//   late TextEditingController descModelController;
//
//   List<int>? valuesThumb;
//
//   @override
//   void initState() {
//     super.initState();
//     flutterWebViewPlugin = FlutterWebviewPlugin();
//
//     nameModelController = TextEditingController();
//     authorModelController = TextEditingController();
//     descModelController = TextEditingController();
//
//     // _initServer();
//     flutterWebViewPlugin.close();
//
//     flutterWebViewPlugin.onStateChanged.listen((state) {
//       if (enableReload && state.type == WebViewState.finishLoad) {
//         _initModel();
//         enableReload = false;
//       }
//     });
//   }
//
//   // _initServer() async {
//   //   server = LocalAssetsServer(
//   //     address: InternetAddress.loopbackIPv4,
//   //     assetsBasePath: 'blockbench',
//   //     logger: const DebugLogger(),
//   //   );
//
//   //   final address = await server.serve();
//
//   //   setState(() {
//   //     this.address = address.address;
//   //     port = server.boundPort!;
//   //     debugPrint('address: ${'http://$address:$port'}');
//   //   });
//   // }
//
//   _reload() async {
//     final result = await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return WillPopScope(
//           onWillPop: () => Future.value(false),
//           child: AlertDialog(
//             title: Text('Confirm Reload?',
//                 style: Theme
//                     .of(context)
//                     .textTheme
//                     .titleMedium),
//             content: const Text('Changes you made may not be saved.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context, false);
//                 },
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                   onPressed: () => Navigator.pop(context, true),
//                   child: const Text('Reload')),
//             ],
//           ),
//         );
//       },
//     );
//
//     if (result) flutterWebViewPlugin.reload();
//   }
//
//   @override
//   void dispose() {
//     flutterWebViewPlugin.dispose();
//     // server.stop();
//     nameModelController.dispose();
//     authorModelController.dispose();
//     descModelController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery
//         .of(context)
//         .size;
//     colorScheme = Theme
//         .of(context)
//         .colorScheme;
//     return WillPopScope(
//       onWillPop: () async {
//         try {
//           final result =
//           await flutterWebViewPlugin.evalJavascript('window.warningBack()');
//           if (result != null) {
//             return Future.value(false);
//           } else {
//             Navigator.pop(context);
//             return Future.value(true);
//           }
//         } catch (e) {
//           Navigator.pop(context);
//           return Future.value(true);
//         }
//       },
//       child: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder(
//                 future: Future.delayed(const Duration(milliseconds: 300)),
//                 builder: (context, state) {
//                   if (state.connectionState == ConnectionState.done) {
//                     return WebviewScaffold(
//                       key: const Key("WebViewScaffold"),
//                       url: 'http://$address:$port',
//                       // url: 'https://web.blockbench.net/',
//                       mediaPlaybackRequiresUserGesture: false,
//                       appBar: AppBar(
//                         backgroundColor: Colors.amber,
//                         title: const Text('BlockBench WebView'),
//                         leading: IconButton(
//                           onPressed: () async {
//                             // final result = await flutterWebViewPlugin
//                             //     .evalJavascript('window.warningBack()');
//                             // if (result == null) Navigator.pop(context);
//
//                             // editController.isLoading.value =
//                             // false;
//                             // Get.back();
//                           },
//                           icon: const Icon(Icons.arrow_back_rounded),
//                         ),
//                         actions: [
//                           IconButton(
//                             onPressed: () async {
//                               await flutterWebViewPlugin
//                                   .evalJavascript('window.allowPickFile()');
//                             },
//                             icon: Icon(
//                               Icons.import_export_rounded,
//                               color: Theme
//                                   .of(context)
//                                   .colorScheme
//                                   .surface,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               var result =
//                               await flutterWebViewPlugin.evalJavascript(
//                                   "window.saveDataModelToApp()");
//                               if (result != null && result != 'null') {
//                                 Map? popResult;
//                                 try {
//                                   if (Platform.isAndroid) {
//                                     popResult = jsonDecode(
//                                         jsonDecode(result.toString()));
//                                   } else {
//                                     popResult = jsonDecode(result.toString());
//                                   }
//                                 } catch (e) {
//                                   debugPrint('error jsonDecode $e');
//                                   try {
//                                     if (Platform.isAndroid) {
//                                       popResult = jsonDecode(
//                                           jsonDecode(result.toString()));
//                                     } else {
//                                       popResult = jsonDecode(result.toString());
//                                     }
//                                   } catch (e2) {
//                                     debugPrint('$e2');
//                                     popResult = widget.data['geoJson'];
//                                     // FirebaseCrashlytics.instance.log('$e');
//                                     // FirebaseCrashlytics.instance.log('$e2');
//                                   }
//                                 }
//
//                                 Navigator.pop(context, popResult);
//                               }
//                             },
//                             icon: Icon(Icons.save,
//                                 color: Theme
//                                     .of(context)
//                                     .colorScheme
//                                     .surface),
//                           ),
//                         ],
//                       ),
//                       withZoom: true,
//                       withLocalStorage: true,
//                       hidden: false,
//                       javascriptChannels: {
//                         JavascriptChannel(
//                             name: 'WarningBack',
//                             onMessageReceived:
//                                 (JavascriptMessage message) async {
//                               if (message.message == 'true')
//                                 Navigator.pop(context);
//                             }),
//                         // JavascriptChannel(
//                         //     name: 'AllowPickFile',
//                         //     onMessageReceived:
//                         //         (JavascriptMessage message) async {
//                         //       debugPrint('message.message: ${message.message}');
//                         //       if (message.message == 'true') {
//                         //         FilePickerResult? result = await FilePicker
//                         //             .platform
//                         //             .pickFiles(type: FileType.any);
//                         //         if (result != null) {
//                         //           File filePicked =
//                         //           File(result.files.single.path!);
//                         //           if (filePicked.path.endsWith(".json")) {
//                         //             final GlobalKey<ScaffoldState>
//                         //             _scaffoldKey =
//                         //             GlobalKey<ScaffoldState>();
//                         //             final modelData =
//                         //             filePicked.readAsStringSync();
//                         //             var mapJson = await ModelFunc.getInstance()
//                         //                 .checkModelsDataNew(
//                         //                 filePicked.path,
//                         //                 context,
//                         //                 _scaffoldKey,
//                         //                 jsonDecode(modelData));
//                         //
//                         //             if (mapJson != null) {
//                         //               Map<String, dynamic> newModel = {
//                         //                 "model": mapJson
//                         //               };
//                         //
//                         //               log('newModelData: ${jsonEncode(
//                         //                   newModel)}');
//                         //
//                         //               await flutterWebViewPlugin.evalJavascript(
//                         //                   'window.loadNewModelApp(${jsonEncode(
//                         //                       newModel)})');
//                         //             }
//                         //           } else {
//                         //             final base64 = base64Encode(
//                         //                 filePicked.readAsBytesSync());
//                         //             log(
//                         //                 'base64 data: ${'data:image/png;base64,$base64'}');
//                         //             await flutterWebViewPlugin.evalJavascript(
//                         //                 'window.loadTextureApp("${p.basename(
//                         //                     filePicked
//                         //                         .path)}", "data:image/png;base64,$base64")');
//                         //           }
//                         //         }
//                         //       }
//                         //     }),
//                       },
//                       initialChild: Container(
//                         color: const Color(0xFF16191D),
//                         width: size.width,
//                         height: size.height,
//                         child: Center(
//                             child: Image.asset(
//                                 'assets/icons/blockbench_logo.png',
//                                 height: 100,
//                                 width: 100)),
//                       ),
//                     );
//                   }
//                   return Scaffold(
//                     appBar: AppBar(title: const Text('BlockBench WebView')),
//                     body: Container(
//                       color: const Color(0xFF16191D),
//                       width: SizeApp
//                           .getInstance()
//                           .widthScreen,
//                       height: SizeApp
//                           .getInstance()
//                           .heightScreen,
//                       child: Center(
//                           child: Image.asset('assets/icons/blockbench_logo.png',
//                               height: 100, width: 100)),
//                     ),
//                   );
//                 }),
//           ),
//           Divider(height: 1, color: colorScheme.outline),
//           Container(
//             color: const Color(0xFF171A1F),
//             child: Material(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     onPressed: () async {
//                       await flutterWebViewPlugin
//                           .evalJavascript("window.undoFromApp()");
//                     },
//                     icon: const Icon(Icons.undo_rounded),
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       await flutterWebViewPlugin
//                           .evalJavascript("window.redoFromApp()");
//                     },
//                     icon: const Icon(Icons.redo_rounded),
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       final result = await _reload();
//                       if (result) {
//                         await flutterWebViewPlugin.reload();
//                         await flutterWebViewPlugin.show();
//                         enableReload = true;
//                       }
//                     },
//                     icon: const Icon(Icons.refresh_rounded),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
