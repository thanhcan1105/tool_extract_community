import 'package:archive/archive.dart';

class ModelAllDataAddon {
  // Behavior Pack
  List<AddonExtractModel> listBlockBP = [];
  List<AddonExtractModel> listAnimationsBP = [];
  List<AddonExtractModel> listAnimationControllersBP = [];

  // Resource Pack
  List<AddonExtractModel> listEntityRP = [];
  List<AddonExtractModel> listModelRP = [];
  List<AddonExtractModel> listTextureRP = [];
  List<AddonExtractModel> listAnimationsRP = [];
  List<AddonExtractModel> listAnimationControllersRP = [];

  // Other
  AddonExtractModel terrainTextureData = AddonExtractModel();
  AddonExtractModel blockJsonRP = AddonExtractModel();

  ModelAllDataAddon({
    List<AddonExtractModel>? listBlockBP,
    List<AddonExtractModel>? listEntityRP,
    List<AddonExtractModel>? listModelRP,
    List<AddonExtractModel>? listTextureRP,
    List<AddonExtractModel>? listAnimationsRP,
    List<AddonExtractModel>? listAnimationControllersRP,
    List<AddonExtractModel>? listAnimationsBP,
    List<AddonExtractModel>? listAnimationControllersBP,
    AddonExtractModel? terrainTextureData,
    AddonExtractModel? blockJsonRP,
  }) {
    // Initialize lists if provided, else use defaults
    this.listBlockBP = listBlockBP ?? [];
    this.listAnimationsBP = listAnimationsBP ?? [];
    this.listAnimationControllersBP = listAnimationControllersBP ?? [];
    this.listEntityRP = listEntityRP ?? [];
    this.listModelRP = listModelRP ?? [];
    this.listTextureRP = listTextureRP ?? [];
    this.listAnimationsRP = listAnimationsRP ?? [];
    this.listAnimationControllersRP = listAnimationControllersRP ?? [];
    this.terrainTextureData = terrainTextureData ?? AddonExtractModel();
    this.blockJsonRP = blockJsonRP ?? AddonExtractModel();
  }
}

class AddonExtractModel {
  String? name;
  ArchiveFile? data;

  AddonExtractModel({this.name, this.data});
}

class ErrorExtractModel {
  String? name;
  String? data;

  ErrorExtractModel({this.name, this.data});
}
