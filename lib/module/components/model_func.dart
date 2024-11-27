import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:path/path.dart' as p;
import 'model_geometry.dart';

bool isVersion12 = false;
// UnityWidgetController? unityWidgetController;

class ModelFunc {
  static ModelFunc? _instance;

  ModelFunc._internal();

  static ModelFunc getInstance() {
    _instance ??= ModelFunc._internal();
    return _instance!;
  }

  /// View
  //region Actions
  // Future openFilePicker(String keyModel, GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context) async {
  //   context.read<AdsProvider>().setCurrentBannerScreen("selectModel3D");
  //
  //   Map? modelGEO = await selectModel3D(context.read<CubeProvider>(), keyModel, context);
  //   log('modelGEO $modelGEO');
  //   // await unityWidgetController.resume();
  //   // await unityWidgetController.create();
  //   if (modelGEO != null) {
  //     context.read<CubeProvider>().modelJson = modelGEO;
  //     GeometryModel geo = await getGEO(modelGEO);
  //     context.read<CubeProvider>().geo = geo;
  //     setJson(geo);
  //
  //     // print("result " + jsonEncode(Provider.of<Data>(context, listen: false).modelGeo));
  //
  //     context.read<CubeProvider>().updateCubeData(geo);
  //     // setState(() {});
  //   }
  //   // context.read<CubeProvider>().visibleUnityTrue;
  //   context.read<AdsProvider>().setCurrentBannerScreen("Model3D");
  // }

  // Future<dynamic> selectModel3D(CubeProvider provider, String keyModel, BuildContext context) async {
  //   var dataJsonModel = await SharedPreferces.getInstance().getFromStorage(keyModel);
  //   // provider.visibleUnityFalse;
  //   return Navigator.push(context, MaterialPageRoute(
  //     builder: (context) {
  //       List<Map> dataAsset = [];
  //       if (dataJsonModel != null) dataAsset = List.from(json.decode(dataJsonModel));
  //       Future<void> callBack() async {
  //         log(json.encode(dataAsset), name: 'msmsmsmms');
  //         await SharedPreferces.getInstance().saveToStorage(keyModel, json.encode(dataAsset.reversed.toList()));
  //       }
  //
  //       Future<bool> willPopCallback() async {
  //         callBack();
  //         return true;
  //       }
  //
  //       dataAsset = dataAsset.reversed.toList();
  //       return HeightAdsWidget(
  //           screenBanner: "selectModel3D",
  //           child: StatefulBuilder(
  //             builder: (context, setState) {
  //               final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //               // final appProvider = Provider.of<AppProvider>(context);
  //               return WillPopScope(
  //                 onWillPop: willPopCallback,
  //                 child: Scaffold(
  //                   key: _scaffoldKey,
  //                   appBar: AppBar(
  //                     leading: IconButton(
  //                       icon: Icon(Icons.close, color: colorTextDefault),
  //                       onPressed: () {
  //                         callBack();
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                     title: Text(S.of(context).history_models, style: TextStyle(color: colorTextDefault)),
  //                     centerTitle: true,
  //                   ),
  //                   body: Center(
  //                       child: Column(
  //                         children: [
  //                           Expanded(
  //                             child: GridView.builder(
  //                               padding: const EdgeInsets.all(8.0),
  //                               itemCount: dataAsset.length,
  //                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                                   mainAxisSpacing: 8.0, crossAxisSpacing: 8.0, childAspectRatio: 1, crossAxisCount: SizeApp.getInstance().isMobile ? 2 : 4),
  //                               itemBuilder: (BuildContext context, int index) {
  //                                 return GestureDetector(
  //                                     child: Stack(
  //                                       children: <Widget>[
  //                                         Card(
  //                                           child: Container(
  //                                             padding: const EdgeInsets.all(5),
  //                                             width: double.infinity,
  //                                             height: double.infinity,
  //                                             child: Column(
  //                                               children: [
  //                                                 Expanded(
  //                                                     child: Padding(
  //                                                       padding: const EdgeInsets.all(16),
  //                                                       child: Image.asset(
  //                                                         'assets/icons/3Dmodel.png',
  //                                                         color: Theme.of(context).primaryColor,
  //                                                       ),
  //                                                     )),
  //                                                 Container(
  //                                                     height: 50,
  //                                                     color: Theme.of(context).primaryColor,
  //                                                     child: Center(
  //                                                         child: Text(
  //                                                           dataAsset[index]["name"] ?? "",
  //                                                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  //                                                         ))),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         Align(
  //                                             alignment: Alignment.topRight,
  //                                             child: GestureDetector(
  //                                               onTap: () {
  //                                                 dataAsset.removeAt(index);
  //                                                 SharedPreferces.getInstance().saveToStorage(keyModel, json.encode(dataAsset.reversed.toList()));
  //                                                 setState(() {});
  //                                               },
  //                                               child: Container(
  //                                                 width: 24,
  //                                                 height: 24,
  //                                                 color: Colors.red,
  //                                                 child: const Center(child: Icon(Icons.clear, color: Colors.white, size: 13)),
  //                                               ),
  //                                             ))
  //                                       ],
  //                                     ),
  //                                     onTap: () async {
  //                                       callBack();
  //                                       Navigator.of(context).pop(dataAsset[index]["model"] ?? dataAsset[index]);
  //                                     });
  //                               },
  //                             ),
  //                             flex: 10,
  //                           ),
  //                           Expanded(
  //                             flex: 1,
  //                             child: Container(
  //                               padding: const EdgeInsets.all(3),
  //                               child: SizedBox(
  //                                 width: double.infinity,
  //                                 child: MaterialButton(
  //                                   padding: const EdgeInsets.all(10),
  //                                   child: Text(
  //                                     S.of(context).import_model,
  //                                     style: const TextStyle(color: Colors.white),
  //                                   ),
  //                                   color: context.read<ThemeProvider>().itemColor,
  //                                   elevation: 4.0,
  //                                   splashColor: context.read<ThemeProvider>().itemColor,
  //                                   onPressed: () async {
  //                                     // File filePicked = await FilePicker.getFile(
  //                                     //     type: FileType.custom, allowedExtensions: ['mcaddon']);
  //                                     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
  //                                     if (result != null) {
  //                                       if (result.files.single.path!.endsWith(".json")) {
  //                                         File filePicked = File(result.files.single.path!);
  //
  //                                         checkModelsData(filePicked.path, _scaffoldKey, context);
  //                                         var mapJson = await checkModelsDataNew(filePicked.path, context, _scaffoldKey, context.read<CubeProvider>().modelJson);
  //
  //                                         if (mapJson != null) {
  //                                           var dataPath = filePicked.path.split('/');
  //                                           dataAsset.insert(0, {
  //                                             "name": dataPath[dataPath.length - 1],
  //                                             "model": mapJson,
  //                                           });
  //                                           setState(() {});
  //                                         } else {
  //                                           ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
  //                                               .showSnackBar(const SnackBar(content: Text("This isn't model file")));
  //                                         }
  //                                       } else {
  //                                         ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
  //                                             .showSnackBar(const SnackBar(content: Text("allowed .json only")));
  //                                       }
  //                                     }
  //                                   },
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       )),
  //                 ),
  //               );
  //             },
  //           ));
  //     },
  //   ));
  // }

  // Future openFilePicker(
  //     WidgetRef ref, String keyModel, BuildContext context) async {
  //   // // File filePicked = await FilePicker.getFile(
  //   // //     type: FileType.custom, allowedExtensions: ['mcaddon']);
  //   // FilePickerResult result =
  //   // await FilePicker.platform.pickFiles(type: FileType.any);
  //   // if (result != null) {
  //   //   if (result.files.single.path.endsWith(".json")) {
  //   //     File filePicked = File(result.files.single.path);
  //   //     // print("jsonfile : ${filePicked.path}");
  //   //     checkModelsData(filePicked.path);
  //   //   } else {
  //   //     _scaffoldKey.currentState.showSnackBar(SnackBar(
  //   //       content: Text("allowed .json only"),
  //   //     ));
  //   //   }
  //   // }
  //
  //   // context.read<AdsProvider>().setCurrentBannerScreen("selectModel3D");
  //
  //   Map modelJson = await selectModel3D(keyModel, context, ref);
  //   print('modelGEO $modelJson');
  //   ref.read(dataChangeNotifierProvider).modelJson = modelJson;
  //   GeometryModel geo = await ModelFunc.getInstance().getGEO(modelJson);
  //   ref.read(dataChangeNotifierProvider).geo = geo;
  //   setJson(geo);
  //
  //   // print(
  //   //     "result " + jsonEncode(ref.read(dataChangeNotifierProvider).modelGeo));
  //   ref.read(cubeChangeNotifierProvider).updateCubeData(geo);
  //   // setState(() {});
  //   // context.read<AdsProvider>().setCurrentBannerScreen("Model3D");
  // }

  // void saveData(BuildContext context, var modelGeo, var dataBones) {
  //   final provider = context.read<CubeProvider>();
  //   var modelJson = provider.modelJson;
  //   List<dynamic> bones = [];
  //
  //   if (modelJson['format_version'] != null && ["1.12.0", "1.16.0"].contains(modelJson['format_version'].toString())) {
  //     provider.bones?.forEach((element) => bones.add(element.toJson2()));
  //     modelJson['minecraft:geometry'][0]['bones'] = json.decode(json.encode(bones));
  //   } else {
  //     String key = (modelJson as Map).keys.firstWhere((element) => element.toString().contains('geometry'));
  //     provider.bones?.forEach((element) => bones.add(element.toJson2()));
  //     modelJson[key]["bones"] = json.decode(json.encode(bones));
  //   }
  //   Navigator.pop(context, modelJson);
  // }

  //endregion

  //region Unity
  // void onUnityCreated(
  //     controller, var entity, var values, var geo, bool showPivot) async {
  //   unityWidgetController = controller;
  //   if (Platform.isIOS) {
  //     controller.pause();
  //     controller.resume();
  //   }
  //   final _isPaused = await unityWidgetController!.isPaused();
  //   if (_isPaused!) {
  //     Future.delayed(
  //       const Duration(milliseconds: 500),
  //       () async {
  //         await unityWidgetController!.resume();
  //       },
  //     );
  //   }
  //   var dataModel = await getGEO(jsonDecode(geo));
  //
  //   setName(p.basenameWithoutExtension(entity));
  //   setEditorMode();
  //   setTexture(values);
  //   setJson(dataModel);
  //   setBackground('#99999900');
  //   Future.delayed(const Duration(milliseconds: 300))
  //       .then((value) => setPivot(showPivot));
  //   Future.delayed(const Duration(milliseconds: 300))
  //       .then((value) => ModelFunc.getInstance().setPosition(''));
  // }

  // void onUnityMessage(c, message) {
  //   log("Message: $message");
  //   if (message.startsWith("image_url:")) {
  //     completer.complete(message.toString().split('image_url:').last);
  //   }
  //   if (message.startsWith("collision_size:")) {
  //     Locators.fromJson(
  //         json.decode(message.toString().replaceFirst("collision_size:", "")));
  //     // print(data.lead);
  //     // specialAction(data.lead);
  //   }
  // }

  //endregion

  /// Edit
  // region

  //endregion
  Future<GeometryModel> getGEO(Map batgeo) async {
    Map<String, dynamic> bat = {};
    dynamic findOnHit(var components) {
      if (components is Map) {
        for (var entry in components.entries.toList()) {
          if (entry.key == "bones") {
            bat['bones'] = entry.value;
          }
          if (entry.key == "texturewidth") {
            bat['texturewidth'] = entry.value;
          }

          if (entry.key == "textureheight") {
            bat['textureheight'] = entry.value;
          }
          if (entry.key == "texture_width") {
            bat['texturewidth'] = entry.value;
          }

          if (entry.key == "texture_height") {
            bat['textureheight'] = entry.value;
          }
        }
        for (var entry in components.entries.toList()) {
          findOnHit(entry.value);
        }
      } else if (components is List<Map>) {
        for (var entry in components) {
          findOnHit(entry);
        }
      } else {}
    }

    dynamic findOnHit2(var components) {
      if (components is Map) {
        for (var entry in components.entries.toList()) {
          if (entry.key == "bones") {
            bat['bones'] = entry.value;
          }

          if (entry.key == "texture_width") {
            bat['texturewidth'] = entry.value;
          }

          if (entry.key == "texture_height") {
            bat['textureheight'] = entry.value;
          }
        }
        for (var entry in components.entries.toList()) {
          findOnHit2(entry.value);
        }
      } else if (components is List) {
        for (var entry in components) {
          if (entry is Map) {
            findOnHit2(entry);
          }
        }
      } else {}
    }

    if (batgeo['format_version'] != null &&
        ["1.12.0", "1.16.0"].contains(batgeo['format_version'].toString())) {
      isVersion12 = true;
      findOnHit2(batgeo);
    } else {
      findOnHit(batgeo);
    }

    GeometryModel geometryModel = GeometryModel.fromJson(bat);

    geometryModel.versionBedrock = isVersion12;
    return geometryModel;
  }

  Future changeData(BuildContext context, {String value = ''}) async {
    TextEditingController controller = TextEditingController(text: value);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: const Center(child: Text('value')),
          content: TextField(
            cursorColor: Colors.black,
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            decoration: const InputDecoration(
              hintText: 'Input value',
            ),
          ),
          actions: const <Widget>[
            // usually buttons at the bottom of the dialog
            // FlatButton(
            //   shape: Border(),
            //   child: Text(
            //     'cancel',
            //     style: TextStyle(color: Colors.grey),
            //   ),
            //   color: Colors.white,
            //   splashColor: Colors.grey,
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // FlatButton(
            //   child: Text('ok'),
            //   onPressed: () {
            //     Navigator.of(context).pop(controller.text);
            //   },
            // ),
          ],
        );
      },
    );
  }

  // Future<List<int>> getTexture(BuildContext context) async {
  //   final provider = context.read<CubeProvider>();
  //   final data = context.read<DataProvider>();
  //   if (data.skinDir!.contains("assets/")) {
  //     var byteData = await rootBundle.load(data.skinDir!);
  //     provider.values = byteData.buffer.asUint8List();
  //   } else {
  //     provider.values = File('${data.skinDir}').readAsBytesSync();
  //   }
  //   img.Image? photo = img.decodeImage(provider.values!);
  //   if (provider.geo!.textureheight == null) {
  //     provider.geo!.textureheight = photo!.height;
  //   }
  //   if (provider.geo!.texturewidth == null) {
  //     provider.geo!.texturewidth = photo!.width;
  //   }
  //   return provider.values!;
  // }

  // Future getTexture(
  //     WidgetRef ref) async {
  //   final edit = ref.read(editorChangeNotifierProvider);
  //   if (edit.skinModel.contains("assets/")) {
  //     var byteData = await rootBundle.load(edit.skinModel);
  //     edit.values = byteData.buffer.asUint8List();
  //   } else {
  //     edit.values = File('${edit.skinModel}').readAsBytesSync();
  //   }
  //   img.Image? photo = img.decodeImage(edit.values!);
  //
  //   if (edit.geo!.textureheight == null) {
  //     edit.geo!.textureheight = photo!.height;
  //   }
  //   if (edit.geo!.texturewidth == null) {
  //     edit.geo!.texturewidth = photo!.width;
  //   }
  //   return edit.values;
  // }

  // Future<bool> willPopCallback(BuildContext context) async {
  //   var result = (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text('Are you sure?'),
  //           content: Text('Do you want to exit without save?'),
  //           backgroundColor: Theme.of(context).colorScheme.surface,
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child: Text(
  //                 'No',
  //                 style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(true),
  //               child: Text(
  //                 'Yes',
  //                 style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  //               ),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  //   // await _unityWidgetController.pause();
  //   return result;
  // }

  Future<String> readFileString(String path) async {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        await file.create();
      }
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  // Future<bool> checkModelsData(String path, GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context) async {
  //   // final dataProvider = context.read<DataProvider>();
  //   final cubeProvider = context.read<CubeProvider>();
  //   String jsonString = await readFileString(path);
  //   Map basemodelGeo = jsonDecode(jsonEncode(cubeProvider.modelJson));
  //   Map newmodelGeo = json.decode(jsonString);
  //
  //   // print(jsonEncode(basemodelGeo));
  //   String keyGEO = '';
  //   basemodelGeo.forEach((key, value) {
  //     if (key.toString().startsWith('geometry')) {
  //       keyGEO = key;
  //     } else if (key.toString().endsWith('geometry')) {
  //       keyGEO = basemodelGeo[key][0]['description']['identifier'];
  //     }
  //   });
  //   if (keyGEO.isEmpty) {
  //     ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(const SnackBar(content: Text("This isn't model file")));
  //     return false;
  //   }
  //   Map? modelGEO;
  //   Map clone = jsonDecode(jsonEncode(newmodelGeo));
  //   newmodelGeo.forEach((key, value) {
  //     if (key.toString().startsWith('geometry')) {
  //       clone.remove(key);
  //       clone[keyGEO] = value;
  //       modelGEO = clone;
  //     } else if (key.toString().endsWith('geometry')) {
  //       clone[key][0]['description']['identifier'] = keyGEO;
  //       modelGEO = clone;
  //     }
  //   });
  //   cubeProvider.modelJson = modelGEO;
  //   GeometryModel geo = await ModelFunc.getInstance().getGEO(modelGEO!);
  //   cubeProvider.geo = geo;
  //   context.read<CubeProvider>().updateCubeData(geometryModelFromJson(jsonEncode(geo)), reload: false);
  //   setJson(geo);
  //   // cubeProvider.update();
  //   return true;
  // }

  setKeyGeo(Map data, String keyGEO) {
    Map temp = Map.from(data);
//    String keyGEO = getKeyGeo(data);
    temp.forEach((key, value) {
      if (key.toString().startsWith('geometry')) {
        data.remove(key);
        data[keyGEO] = value;
      } else if (key.toString().endsWith('geometry')) {
        data[key][0]['description']['identifier'] = keyGEO;
      }
    });
  }

  Future<Map?>? checkModelsDataNew(String path, BuildContext context,
      GlobalKey<ScaffoldState> _scaffoldKey, var dataModelGeo,
      {jsonStr}) async {
    String jsonString = jsonStr ?? await readFileString(path);
    Map basemodelGeo = jsonDecode(jsonEncode(dataModelGeo));
    Map newmodelGeo = json.decode(jsonString);

    String keyGEO = '';
    basemodelGeo.forEach((key, value) {
      if (key.toString().startsWith('geometry')) {
        keyGEO = key;
      } else if (key.toString().endsWith('geometry')) {
        keyGEO = basemodelGeo[key][0]['description']['identifier'];
      }
    });
    if (keyGEO.isEmpty) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
          .showSnackBar(const SnackBar(content: Text("This isn't model file")));
      return null;
    }
    Map? modelGEO;
    Map clone = jsonDecode(jsonEncode(newmodelGeo));
    newmodelGeo.forEach((key, value) {
      if (key.toString().startsWith('geometry')) {
        clone.remove(key);
        clone[keyGEO] = value;
        modelGEO = clone;
      } else if (key.toString().endsWith('geometry')) {
        clone[key][0]['description']['identifier'] = keyGEO;
        modelGEO = clone;
      }
    });
    return modelGEO!;
  }

  // Future<dynamic> selectModel3D(
  //     String keyModel, BuildContext context, WidgetRef ref) async {
  //   var dataJsonModel =
  //       await SharedPreferces.getInstance().getFromStorage(keyModel);
  //
  //   return Navigator.push(context, MaterialPageRoute(
  //     builder: (context) {
  //       List<Map> dataAsset = [];
  //       if (dataJsonModel != null)
  //         dataAsset = List.from(json.decode(dataJsonModel));
  //       Future<void> callBack() async {
  //         log(json.encode(dataAsset), name: 'msmsmsmms');
  //         await SharedPreferces.getInstance().saveToStorage(
  //             keyModel, json.encode(dataAsset.reversed.toList()));
  //       }
  //
  //       Future<bool> willPopCallback() async {
  //         callBack();
  //         return true;
  //       }
  //
  //       dataAsset = dataAsset.reversed.toList();
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           final GlobalKey<ScaffoldState> _scaffoldKey =
  //               GlobalKey<ScaffoldState>();
  //           // final appProvider = Provider.of<AppProvider>(context);
  //           return WillPopScope(
  //             onWillPop: willPopCallback,
  //             child: Scaffold(
  //               key: _scaffoldKey,
  //               appBar: AppBar(
  //                 leading: IconButton(
  //                   icon: Icon(Icons.close),
  //                   onPressed: () {
  //                     callBack();
  //                     Navigator.pop(context);
  //                   },
  //                 ),
  //                 title: Text('History 3D Models'),
  //                 centerTitle: true,
  //               ),
  //               body: Container(
  //                 child: Center(
  //                     child: Container(
  //                         // color: Colors.grey[300],
  //                         child: Column(
  //                   children: [
  //                     Expanded(
  //                       child: GridView.builder(
  //                         padding: EdgeInsets.all(8.0),
  //                         itemCount: dataAsset.length,
  //                         gridDelegate:
  //                             SliverGridDelegateWithFixedCrossAxisCount(
  //                                 mainAxisSpacing: 8.0,
  //                                 crossAxisSpacing: 8.0,
  //                                 childAspectRatio: 1,
  //                                 crossAxisCount:
  //                                     SizeApp.getInstance().isMobile ? 2 : 4),
  //                         itemBuilder: (BuildContext context, int index) {
  //                           return GestureDetector(
  //                               child: Stack(
  //                                 children: <Widget>[
  //                                   Card(
  //                                     child: Container(
  //                                       padding: EdgeInsets.all(5),
  //                                       width: double.infinity,
  //                                       height: double.infinity,
  //                                       child: Column(
  //                                         children: [
  //                                           Expanded(
  //                                               child: Padding(
  //                                             padding: const EdgeInsets.all(16),
  //                                             child: Image.asset(
  //                                               'assets/icons/3Dmodel.png',
  //                                               color: Theme.of(context)
  //                                                   .primaryColor,
  //                                             ),
  //                                           )),
  //                                           Container(
  //                                               height: 50,
  //                                               color: Theme.of(context)
  //                                                   .primaryColor,
  //                                               child: Center(
  //                                                   child: Text(
  //                                                 dataAsset[index]["name"] ??
  //                                                     "",
  //                                                 style: TextStyle(
  //                                                     fontSize: 18,
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     color: Colors.white),
  //                                               ))),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   Align(
  //                                       alignment: Alignment.topRight,
  //                                       child: GestureDetector(
  //                                         onTap: () {
  //                                           dataAsset.removeAt(index);
  //                                           SharedPreferces.getInstance()
  //                                               .saveToStorage(
  //                                                   keyModel,
  //                                                   json.encode(dataAsset
  //                                                       .reversed
  //                                                       .toList()));
  //                                           setState(() {});
  //                                         },
  //                                         child: Container(
  //                                           width: 24,
  //                                           height: 24,
  //                                           color: Colors.red,
  //                                           child: Center(
  //                                               child: Icon(Icons.clear,
  //                                                   color: Colors.white,
  //                                                   size: 13)),
  //                                         ),
  //                                       ))
  //                                 ],
  //                               ),
  //                               onTap: () async {
  //                                 callBack();
  //                                 Navigator.of(context).pop(dataAsset[index]
  //                                         ["model"] ??
  //                                     dataAsset[index]);
  //                               });
  //                         },
  //                       ),
  //                       flex: 10,
  //                     ),
  //                     //TODO: laguage
  //                     Expanded(
  //                       flex: 1,
  //                       child: Container(
  //                         padding: const EdgeInsets.all(3),
  //                         child: SizedBox(
  //                           width: double.infinity,
  //                           child: RaisedButton(
  //                             padding: const EdgeInsets.all(10),
  //                             child: Text(
  //                               'Import Model 3D',
  //                               style: TextStyle(color: Colors.white),
  //                             ),
  //                             color: Colors.red,
  //                             elevation: 4.0,
  //                             splashColor: Colors.red,
  //                             onPressed: () async {
  //                               // File filePicked = await FilePicker.getFile(
  //                               //     type: FileType.custom, allowedExtensions: ['mcaddon']);
  //                               FilePickerResult? result = await FilePicker
  //                                   .platform
  //                                   .pickFiles(type: FileType.any);
  //                               if (result!.files.single.path!
  //                                   .endsWith(".json")) {
  //                                 File filePicked =
  //                                     File(result.files.single.path!);
  //
  //                                 checkModelsData(
  //                                     filePicked.path, ref, _scaffoldKey);
  //                                 var mapJson = await checkModelsDataNew(
  //                                     filePicked.path,
  //                                     context,
  //                                     _scaffoldKey,
  //                                     ref
  //                                         .read(dataChangeNotifierProvider)
  //                                         .modelJson,
  //                                     jsonStr: json);
  //
  //                                 if (mapJson != null) {
  //                                   var dataPath = filePicked.path.split('/');
  //                                   dataAsset.insert(0, {
  //                                     "name": dataPath[dataPath.length - 1],
  //                                     "model": mapJson,
  //                                   });
  //                                   setState(() {});
  //                                 } else {
  //                                   _scaffoldKey.currentState!
  //                                       .showSnackBar(SnackBar(
  //                                     content: Text("This isn't model file"),
  //                                   ));
  //                                 }
  //                               } else {
  //                                 _scaffoldKey.currentState!
  //                                     .showSnackBar(SnackBar(
  //                                   content: Text("allowed .json only"),
  //                                 ));
  //                               }
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ))),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   ));
  // }

  String toHex2(Color color, {bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}';

  String toHex(Color color, {bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';

  Color toColor(String _rgba) {
    String rgba = _rgba.replaceAll("#", '');
    String color = rgba.replaceRange(0, rgba.length - 2, '');
    String alpha = rgba.replaceRange(rgba.length - 2, rgba.length, '');
    return Color(int.parse('0x${color + alpha}'));
  }

  // void setBackground(String name) {
  //   unityWidgetController!
  //       .postMessage('AppModelRoot', 'setBackgroundModel', name);
  // }

  // Future setPosition(String name) async {
  //   await unityWidgetController!
  //       .postMessage('AppModelRoot', 'setCenterToScreenShot', name);
  // }

  // void setPivot(bool showPivot) {
  //   print('showPivot $showPivot');
  //   unityWidgetController!
  //       .postMessage('AppModelRoot', 'setPivot', showPivot.toString());
  // }
  //
  // void setName(String name) {
  //   unityWidgetController!.postMessage('AppModelRoot', 'setName', name);
  // }

  // void updateTransform(String name) {
  //   unityWidgetController!.postMessage('AppModelRoot', 'updateTransform', name);
  // }

  void showPivot(String name) {
    // updateTransform("body,Cube 0&origin&-4,16,-2");
    // _unityWidgetController.postMessage('AppModelRoot', 'showPivot', name);
  }

  // void setJson(GeometryModel json) {
  //   print('unityWidgetController != null: ${unityWidgetController != null}');
  //   unityWidgetController!
  //       .postMessage('AppModelRoot', 'setJson', jsonEncode(json.toJson()));
  // }

  // void setTexture(List<int> data) {
  //   String imageB64 = base64Encode(data);
  //   unityWidgetController!.postMessage('AppModelRoot', 'setTexture', imageB64);
  // }

  // void getCenter() {
  //   unityWidgetController!
  //       .postMessage('AppModelRoot', 'getCenter', "getCenter");
  // }

  // void setEditorMode() {
  //   print("setEditorMode");
  //   unityWidgetController!.postMessage(
  //     'ControllerPanel',
  //     'setViewType',
  //     // "Model",
  //     "Skin",
  //   );
  // }
  //
  // void setUndoRedo(String type) {
  //   unityWidgetController!.postMessage(
  //     'ControllerPanel',
  //     'setUndoRedo',
  //     type,
  //   );
  // }

  Future<File> writeStringFile(String output, String content) async {
    var pathFix =
        p.dirname(output) + "/" + p.basename(output).replaceAll(":", "_");
    var file = File(
        p.basenameWithoutExtension(output).contains(':') ? pathFix : output);
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    // Write the file
    return file.writeAsString('$content');
  }

  // void onDismissOnlyBeCalledOnce(PopupMenu menu, GlobalKey key) {
  //   menu.show(widgetKey: key);
  // }

  void onDismiss() {
    print('Menu is dismiss');
  }

  // void setJsonEditSkin3D(GeometryModel json, String baseID) {
  //   setName(p.basenameWithoutExtension(baseID.split(":")[1]));
  //   unityWidgetController!.postMessage('AppModelRoot', 'setJson', jsonEncode(json.toJson()));
  // }

  // void saveImage(String url) {
  //   unityWidgetController!.postMessage('AppModelRoot', 'saveImage', url);
  // }
  //
  // void setZoom(int zoom) {
  //   unityWidgetController!
  //       .postMessage('AppModelRoot', 'setZoom', zoom.toString());
  // }
  //
  // void setColor(String speed) {
  //   unityWidgetController!.postMessage(
  //     'ControllerPanel',
  //     'setColor',
  //     speed,
  //   );
  // }

  // void setBrushType(BrushType type) {
  //   unityWidgetController!.postMessage(
  //     'ControllerPanel',
  //     'setBrushType',
  //     BrushType.values.indexOf(type).toString(),
  //   );
  // }

  // void setBrushSize(int size) {
  //   unityWidgetController!.postMessage(
  //     'ControllerPanel',
  //     'setBrushSize',
  //     size.toString(),
  //   );
  // }
  //
  // late Completer completer;
  //
  // Future takeScreenshot(String path) async {
  //   unityWidgetController!
  //       .postMessage('AppModelRoot', 'SaveScreenshotAsPNG', path);
  //   completer = Completer();
  //   return completer.future;
  // }
}
