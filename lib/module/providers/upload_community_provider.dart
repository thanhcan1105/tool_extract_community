import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;
import 'dart:html' as html;

import '../models/addon_model.dart';
import '../models/any_model.dart';

enum AppsNameEnum { vehicle, furniture, gun, mob }

class UploadCommunityProvider with ChangeNotifier {
  UploadCommunityProvider() {
    _extractAddon();
  }

  List<ErrorExtractModel> errorFileName = [];

  final ModelAllDataAddon _modelAllDataAddon = ModelAllDataAddon();
  final List<AddonModels> _listAddonExtracted = <AddonModels>[];

  List<AddonModels> get listAddonExtracted => _listAddonExtracted;

  AppsNameEnum? _appName;

  AppsNameEnum? get communityName => _appName;

  void setCommunityName(AppsNameEnum value) {
    _appName = value;
    notifyListeners();
  }

  void downloadZip() {
    final archive = Archive();

    // Thêm các file vào archive
    for (final item in _modelAllDataAddon.listEntityRP) {
      archive.addFile(item.data!);
    }
    // Nén archive thành byte array
    final zipData = ZipEncoder().encode(archive)!;

    // Tạo blob và tải xuống
    final blob = html.Blob([zipData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = 'my_files.zip'
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _extractAddon() async {
    // print("extractAddon");
    // _clearData();

    await Future.delayed(const Duration(milliseconds: 50));
    await _handleExtractData();
    await _handleDataEntity();
    await _handleDataBlock();
    // isLoading.value = false;
    notifyListeners();
  }

  Future<void> _handleExtractData() async {
    final bytes = await rootBundle.load("assets/BicyclesCraftMinecraftFurnitureMob.zip");
    Archive archiveRaw = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
    Archive archive = Archive();
    for (final file in archiveRaw) {
      if (file.name.contains(".json")) {
        archive.addFile(file);
      }
      if (file.name.contains(".png")) {
        archive.addFile(file);
      }
    }

    String resource = '';
    String behavior = '';
    var manifestRepo = await _getManifestAddon(archive, behavior, resource);
    resource = manifestRepo["resource"];
    behavior = manifestRepo["behavior"];
    if (resource.isEmpty || behavior.isEmpty) {
      errorFileName.add(ErrorExtractModel(name: "test" /*filePicked.name*/, data: "-- Lỗi zip"));
    }

    for (final file in archive) {
      ///behavior

      ///resource
      if (file.name.contains("$resource/entity/")) {
        if (file.isFile) {
          _modelAllDataAddon.listEntityRP.add(AddonExtractModel(name: file.name, data: file));
        }
      }

      //
      if (file.name.contains("$resource/animations/")) {
        print(file);
        if (file.isFile) {
          _modelAllDataAddon.listAnimationsRP.add(AddonExtractModel(name: file.name, data: file));
        }
      }

      //
      if (file.name.contains("$resource/animation_controllers/")) {
        if (file.isFile) {
          _modelAllDataAddon.listAnimationControllersRP.add(AddonExtractModel(name: file.name, data: file));
        }
      }

      //
      if (file.name.contains("$resource/models/")) {
        if (file.isFile) {
          String modelName = "";
          var repo = await repairJSData(file.content);
          if (repo.containsKey("minecraft:geometry")) {
            modelName = repo["minecraft:geometry"][0]["description"]["identifier"];
          }
          _modelAllDataAddon.listModelRP.add(AddonExtractModel(name: modelName, data: file));
        }
      }

      //
      if (file.name.contains("$resource/textures/")) {
        if (file.isFile && !file.name.contains(".json")) {
          _modelAllDataAddon.listTextureRP.add(AddonExtractModel(
            name: file.name,
            data: file,
          ));
        }
      }

      //
      if (file.name.contains("$resource/textures/terrain_texture.json")) {
        _modelAllDataAddon.terrainTextureData = AddonExtractModel(name: file.name, data: file);
      }

      //
      if (file.name.contains("$resource/blocks.json")) {
        _modelAllDataAddon.blockJsonRP = AddonExtractModel(name: file.name, data: file);
      }
    }
  }

  Future<void> _handleDataEntity() async {
    for (var item in _modelAllDataAddon.listEntityRP) {
      print("\n-------------------resource start-------------------\n");
      AddonModels defaultData = AddonModels.defaultData();
      var fileContent = await repairJSData(item.data?.content);

      defaultData.addonName = item.name;

      var entity = fileContent['minecraft:client_entity']['description']['geometry'];

      // get model
      var model3DName = fileContent['minecraft:client_entity']['description']['geometry']['default'];
      for (var element in _modelAllDataAddon.listModelRP) {
        if (element.name == model3DName) {
          var jsonElement = await repairJSData(element.data?.content);
          defaultData.modelsRP = AddonDataModel(name: element.name, data: jsonEncode(jsonElement));
        }
      }

      // get texture
      var data = fileContent['minecraft:client_entity']['description']['textures'].values.first;
      if (_modelAllDataAddon.listTextureRP.isNotEmpty) {
        var ttContext = _modelAllDataAddon.listTextureRP.firstWhere((element) => element.name!.contains("$data.png")).data!.content;
        defaultData.textureRP = AddonDataModel(name: data, data: ttContext.toString());
      }

      //
      listAddonExtracted.add(defaultData);
    }
  }

  Future<void> _handleDataBlock() async {
    for (var item in _modelAllDataAddon.listEntityRP) {}
  }

  Future<Map> repairJSData(Uint8List fileData) async {
    var errorJson = utf8.decode(fileData);
    var repoData = js.context.callMethod('myFunc', [errorJson]);
    return jsonDecode(repoData);
  }

  Future<Map> _getManifestAddon(Archive archive, String behavior, String resource) async {
    var manifest = archive.where((element) => element.name.contains('manifest.json'));
    for (var file in manifest) {
      if (file.name.contains("manifest.json")) {
        var fileContent = await repairJSData(file.content);
        var getType = await fileContent['modules'].first['type'];
        if (getType == "data") {
          behavior = file.name.split("/").first;
        } else if (getType == "resources") {
          resource = file.name.split("/").first;
        }
      }
    }
    return {"behavior": behavior, "resource": resource};
  }
}