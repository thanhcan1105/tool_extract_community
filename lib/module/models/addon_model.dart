import 'any_model.dart';

class AddonModels {
  // Behavior Pack
  String? addonName;
  AddonDataModel? identifier;
  AddonDataModel? formatVersion;
  List<AddonDataModel>? animationsBP;
  List<AddonDataModel>? animationControllersBP;
  AddonDataModel entitiesBP;
  List<AddonDataModel>? functionsBP;
  List<AddonDataModel>? animationsRP;
  List<AddonDataModel>? animationControllersRP;
  AddonDataModel entityRP;
  List<AddonDataModel>? materialsRP;
  AddonDataModel modelsRP;
  List<AddonDataModel>? particleRP;
  List<AddonDataModel>? particleImg;
  List<AddonDataModel>? renderControllersRp;
  AddonDataModel? textureRP;
  AddonDataModel itemRP;

  AddonModels({
    addonName,
    identifier,
    formatVersion,
    animationsBP,
    animationControllersBP,
    required this.entitiesBP,
    functionsBP,
    animationsRP,
    animationControllersRP,
    required this.entityRP,
    required this.materialsRP,
    required this.modelsRP,
    particleRP,
    particleImg,
    renderControllersRp,
    textureRP,
    required this.itemRP,
  }) {
    this.addonName = addonName ?? '';
    this.identifier = identifier ?? AddonDataModel();
    this.formatVersion = formatVersion ?? AddonDataModel();
    this.animationsBP = animationsBP ?? [];
    this.animationControllersBP = animationControllersBP ?? [];
    this.functionsBP = functionsBP ?? [];
    this.animationsRP = animationsRP ?? [];
    this.animationControllersRP = animationControllersRP ?? [];
    this.particleRP = particleRP ?? [];
    this.particleImg = particleImg ?? [];
    this.renderControllersRp = renderControllersRp ?? [];
    this.textureRP = textureRP ?? AddonDataModel();
  }

  AddonModels.defaultData()
      : addonName = '',
        identifier = AddonDataModel(),
        formatVersion = AddonDataModel(),
        animationsBP = [],
        animationControllersBP = [],
        entitiesBP = AddonDataModel(),
        functionsBP = [],
        animationsRP = [],
        animationControllersRP = [],
        entityRP = AddonDataModel(),
        materialsRP = [],
        modelsRP = AddonDataModel(),
        particleRP = [],
        particleImg = [],
        renderControllersRp = [],
        textureRP = AddonDataModel(),
        itemRP = AddonDataModel();
}

class AddonDataModel {
  String? name;
  String? data;

  AddonDataModel({this.name, this.data});
}
