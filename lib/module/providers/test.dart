// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:archive/archive.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:js' as js;
//
// class UploadCommunityProvider with ChangeNotifier {
//   UploadCommunityProvider() {
//     extractAddon();
//   }
//
//   List<PlatformFile> filesPicked = [];
//
//   ValueNotifier<bool> isLoading = ValueNotifier(false);
//
//   List<GetDataAddonModel> listBlockBP = []; //lay data tu cai nay
//   List<GetDataAddonModel> listEntityRP = []; //hoac lay data tu cai nay
//   List<GetDataAddonModel> listModelRP = [];
//   List<GetDataAddonModel> listTextureRP = [];
//   List<GetDataAddonModel> listAnimationsRP = [];
//   List<GetDataAddonModel> listAnimationControllersRP = [];
//   List<GetDataAddonModel> listAnimationsBP = [];
//   List<GetDataAddonModel> listAnimationControllersBP = [];
//   late ArchiveFile terrainTextureData = ArchiveFile("", 0, "");
//   late ArchiveFile blockJsonRP = ArchiveFile("", 0, "");
//
//   String folderPathExtracted = "";
//
//   List<ErrorAddonModel> errorFileName = [];
//
//   Future<void> pickAddon() async {
//     FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (pickerResult != null) {
//       filesPicked = pickerResult.files;
//     }
//     notifyListeners();
//   }
//
//   _clearData() {
//     listBlockBP.clear();
//     listEntityRP.clear();
//     listModelRP.clear();
//     listTextureRP.clear();
//     errorFileName.clear();
//     terrainTextureData = ArchiveFile("", 0, "");
//     blockJsonRP = ArchiveFile("", 0, "");
//   }
//
//   Future<void> extractAddon() async {
//     print("extractAddon");
//     _clearData();
//     Directory directory = await getApplicationDocumentsDirectory();
//     var now = DateTime.now();
//     String nameTime = "${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}";
//     folderPathExtracted = "${directory.path}/data_exported_$nameTime";
//     Directory(folderPathExtracted).create(recursive: true);
//     isLoading.value = true;
//     await Future.delayed(const Duration(milliseconds: 50));
//     await _handleExtractData();
//     await _handleDataEntity();
//     await _handleDataBlock();
//     isLoading.value = false;
//     notifyListeners();
//   }
//
//   Future<void> _handleExtractData() async {
//     // for (var filePicked in filesPicked) {
//     //   try {
//
//     Archive archiveRaw = Archive();
//     // final bytes = File(filePicked.path ?? "").readAsBytesSync();
//     // archiveRaw = ZipDecoder().decodeBytes(bytes);
//
//     final bytes = await rootBundle.load("assets/BicyclesCraftMinecraftFurnitureMob.zip");
//     archiveRaw = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
//
//     Archive archive = Archive();
//
//     for (final file in archiveRaw) {
//       if (file.name.contains(".json")) {
//         archive.addFile(file);
//       }
//       if (file.name.contains(".png")) {
//         archive.addFile(file);
//       }
//     }
//
//     String resource = '';
//     String behavior = '';
//     var manifestRepo = await _getManifestAddon(archive, behavior, resource);
//     resource = manifestRepo["resource"];
//     behavior = manifestRepo["behavior"];
//
//     if (resource.isEmpty || behavior.isEmpty) {
//       errorFileName.add(ErrorAddonModel(name: "test" /*filePicked.name*/, data: "-- Lỗi zip"));
//     }
//
//     print("-----------------------");
//
//     /// behavior pack
//
//     // get block data
//     for (final file in archive) {
//       if (file.name.contains("$behavior/blocks")) {
//         if (file.isFile) {
//           //get name file
//           String blockName = "";
//           var repo = await repairJSData(file.content);
//           blockName = repo['minecraft:block']['description']['identifier'];
//           listBlockBP.add(GetDataAddonModel(
//             name: blockName,
//             data: file,
//           ));
//         }
//       }
//     }
//
//     /// resource pack
//
//     //get animation
//     // for (final file in archive) {
//     //   if (file.name.contains("$resource/animations")) {
//     //     print("1")
//     //     if (file.isFile) {
//     //       print(file);
//     //       /*//get name file
//     //       String modelName = "";
//     //       var repo = await repairJSData(file.content);
//     //       //case binh thuong ton tai key minecraft:geometry va mot key id nam o key
//     //       if (repo.containsKey("minecraft:geometry")) {
//     //         modelName = repo["minecraft:geometry"][0]["description"]["identifier"];
//     //       }
//     //       listModelRP.add(GetDataAddonModel(
//     //         name: modelName,
//     //         data: file,
//     //       ));*/
//     //     }
//     //   }
//     // }
//
//     //get model
//     for (final file in archive) {
//       if (file.name.contains("$resource/models")) {
//         if (file.isFile) {
//           //get name file
//           String modelName = "";
//           var repo = await repairJSData(file.content);
//           //case binh thuong ton tai key minecraft:geometry va mot key id nam o key
//           if (repo.containsKey("minecraft:geometry")) {
//             modelName = repo["minecraft:geometry"][0]["description"]["identifier"];
//           }
//           listModelRP.add(GetDataAddonModel(
//             name: modelName,
//             data: file,
//           ));
//         }
//       }
//     }
//
//     //get entity resource
//     for (final file in archive) {
//       if (file.name.contains("$resource/entity")) {
//         if (file.isFile) {
//           //get name file
//           String modelName = "";
//           var repo = await repairJSData(file.content);
//           //case binh thuong ton tai key minecraft:geometry va mot key id nam o key
//           if (repo.containsKey("minecraft:client_entity")) {
//             modelName = repo["minecraft:client_entity"]["description"]["identifier"];
//           }
//           listEntityRP.add(GetDataAddonModel(
//             name: modelName,
//             data: file,
//           ));
//         }
//       }
//     }
//
//     //get texture
//     for (final file in archive) {
//       if (file.name.contains("$resource/textures")) {
//         if (file.isFile && !file.name.contains(".json")) {
//           listTextureRP.add(GetDataAddonModel(
//             name: file.name,
//             data: file,
//           ));
//         }
//       }
//     }
//
//     //get terrain texture
//     for (final file in archive) {
//       if (file.name.contains("$resource/textures/terrain_texture.json")) {
//         terrainTextureData = file;
//       }
//     }
//     //get block json rp
//     for (final file in archive) {
//       if (file.name.contains("$resource/blocks.json")) {
//         blockJsonRP = file;
//       }
//     }
//     // } catch (e) {
//     //   errorFileName.add(ErrorAddonModel(name: filePicked.name, data: "-- Lỗi tách addon"));
//     // }
//     // }
//   }
//
//   Future<void> _handleDataBlock() async {
//     for (var element in listBlockBP) {
//       try {
//         String pathFolderParentName = "$folderPathExtracted/blocks";
//         print("\n-------------------behavior start-------------------\n");
//         var addonName = _formatString(element.name ?? "");
//         String dataModel = "";
//         Uint8List dataTexture = Uint8List(0);
//         var jsonDataBlock = await repairJSData(element.data?.content);
//
//         //get model resource pack
//         var model3DName = jsonDataBlock['minecraft:block']['components']['minecraft:geometry'];
//         for (var element in listModelRP) {
//           if (element.name == model3DName) {
//             var jsonElement = await repairJSData(element.data?.content);
//             dataModel = const JsonEncoder.withIndent("  ").convert(jsonElement);
//           }
//         }
//
//         //get texture by block
//         var getTextureNameBlock = jsonDataBlock['minecraft:block']['components']['minecraft:material_instances']['*']['texture'];
//
//         var getTerrainTextureData = json.decode(utf8.decode(terrainTextureData.content));
//         if (getTerrainTextureData.toString().contains(getTextureNameBlock)) {
//           var data = getTerrainTextureData['texture_data'][getTextureNameBlock]['textures'].first;
//           var ttContext = listTextureRP.firstWhere((element) => element.name!.contains("$data.png")).data!.content;
//           dataTexture = ttContext;
//         }
//         if (dataTexture.isNotEmpty || dataModel.isNotEmpty) {
//           writeImage(
//             "$pathFolderParentName/$addonName/${element.name!.split(":").last}.png",
//             dataTexture,
//           );
//
//           writeFile(
//             "$pathFolderParentName/$addonName/${element.name!.split(":").last}.json",
//             dataModel,
//           );
//         }
//       } catch (e) {
//         errorFileName.add(
//           ErrorAddonModel(
//             name: e.toString(),
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> _handleDataEntity() async {
//     for (var element in listEntityRP) {
//       try {
//         print("\n------------------resource start-------------------\n");
//         String pathFolderParentName = "$folderPathExtracted/entity";
//         var entityData = jsonDecode(utf8.decode(element.data?.content));
//         var addonName = _formatString(element.name ?? "");
//
//         String dataModel = "";
//         List<String> nimationsData = [];
//         Uint8List dataTexture = Uint8List(0);
//
//         //get animation RP
//         var animationsRP = entityData['minecraft:client_entity']['description']['animations'];
//         List<String> valuesAnimationsRP = [];
//         animationsRP.forEach((key, value) {
//           valuesAnimationsRP.add(value);
//         });
//
//         print(listAnimationsRP.length);
//
//         //get animations controllers RP
//         var animationControllersRPName = entityData['minecraft:client_entity']['description']['animation_controllers'];
//
//         // get model
//         var model3DName = entityData['minecraft:client_entity']['description']['geometry']['default'];
//         for (var element in listModelRP) {
//           if (element.name == model3DName) {
//             var jsonElement = await repairJSData(element.data?.content);
//             dataModel = const JsonEncoder.withIndent("  ").convert(jsonElement);
//           }
//         }
//
//         var data = entityData['minecraft:client_entity']['description']['textures'].values.first;
//         var ttContext = listTextureRP.firstWhere((element) => element.name!.contains("$data.png")).data!.content;
//         dataTexture = ttContext;
//
//         if (dataTexture.isNotEmpty || dataModel.isNotEmpty) {
//           writeImage(
//             "$pathFolderParentName/$addonName/${element.name!.split(":").last}.png",
//             dataTexture,
//           );
//
//           writeFile(
//             "$pathFolderParentName/$addonName/${element.name!.split(":").last}.json",
//             dataModel,
//           );
//         }
//       } catch (e) {
//         errorFileName.add(
//           ErrorAddonModel(
//             name: e.toString(),
//           ),
//         );
//       }
//     }
//   }
//
//   String _formatString(String input) {
//     String cleanedString = input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ');
//     List<String> words = cleanedString.split(RegExp(r'\s+'));
//     String formattedString = words.map((word) {
//       if (word.isNotEmpty) {
//         return word[0].toUpperCase() + word.substring(1).toLowerCase();
//       } else {
//         return '';
//       }
//     }).join(' ');
//     return formattedString;
//   }
//
//   Future<void> writeFile(String filePath, String content) async {
//     String folderPath = Directory(filePath).parent.path;
//     Directory folder = Directory(folderPath);
//     if (!await folder.exists()) {
//       await folder.create(recursive: true);
//     }
//     File file = File(filePath);
//     await file.writeAsString(content);
//   }
//
//   Future<void> writeImage(String filePath, Uint8List content) async {
//     String folderPath = Directory(filePath).parent.path;
//     Directory folder = Directory(folderPath);
//     if (!await folder.exists()) {
//       await folder.create(recursive: true);
//     }
//     File file = File(filePath);
//     await file.writeAsBytes(content);
//   }
//
//   Future<Map> repairJSData(Uint8List fileData) async {
//     var errorJson = utf8.decode(fileData);
//     var repoData = js.context.callMethod('myFunc', [errorJson]);
//     return jsonDecode(repoData);
//   }
//
//   Future<Map> _getManifestAddon(Archive archive, String behavior, String resource) async {
//     var manifest = archive.where((element) => element.name.contains('manifest.json'));
//     for (var file in manifest) {
//       if (file.name.contains("manifest.json")) {
//         var fileContent = await repairJSData(file.content);
//         var getType = await fileContent['modules'].first['type'];
//         if (getType == "data") {
//           behavior = file.name.split("/").first;
//         } else if (getType == "resources") {
//           resource = file.name.split("/").first;
//         }
//       }
//     }
//     return {"behavior": behavior, "resource": resource};
//   }
// }
//
// class GetDataAddonModel {
//   String? name;
//   ArchiveFile? data;
//
//   GetDataAddonModel({this.name, this.data});
// }
//
// class SetDataAddonModel {
//   String? name;
//   String? data;
//
//   SetDataAddonModel({this.name, this.data});
// }
//
// class ErrorAddonModel {
//   String? name;
//   String? data;
//
//   ErrorAddonModel({this.name, this.data});
// }
