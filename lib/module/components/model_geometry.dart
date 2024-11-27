import 'dart:convert';

GeometryModel geometryModelFromJson(String str) =>
    GeometryModel.fromJson(json.decode(str));

List<Bone> boneFromJson(String str) =>
    List<Bone>.from(json.decode(str).map((x) => Bone.fromJson(x)));

String geometryModelToJson(GeometryModel data) => json.encode(data.toJson());

String boneToJson(List<Bone> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GeometryModel {
  GeometryModel({
    this.visibleBoundsWidth,
    this.visibleBoundsHeight,
    this.visibleBoundsOffset,
    this.bones,
    this.texturewidth,
    this.textureheight,
    this.versionBedrock,
  });

  double? visibleBoundsWidth;
  double? visibleBoundsHeight;
  List<num>? visibleBoundsOffset;
  List<Bone>? bones;
  num? texturewidth;
  num? textureheight;
  bool? versionBedrock = false;

  factory GeometryModel.fromJson(Map<String, dynamic> json) => GeometryModel(
        bones: List<Bone>.from(json["bones"].map((x) => Bone.fromJson(x))),
        texturewidth: json["texturewidth"],
        textureheight: json["textureheight"],
        versionBedrock: json["versionBedrock"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> a = {
      "bones": List<dynamic>.from(bones!.map((x) => x.toJson())),
      "texturewidth": texturewidth,
      "textureheight": textureheight,
      "versionBedrock": versionBedrock,
    };
    for (var entry in a.entries.toList()) {
      if (entry.value == null) {
        a.remove(entry.key);
      }
    }
    return a;
  }
}

class Bone {
  Bone({
    this.name,
    this.binding,
    this.pivot,
    this.cubes,
    this.parent,
    this.locators,
    this.mirror,
    this.rotation,
    this.bindPoseRotation,
  });

  String? name;
  String? binding;
  List<num>? pivot;
  List<Cube>? cubes;
  String? parent;
  Locators? locators;
  bool? mirror;
  bool? visible = true;
  List<num>? rotation;
  List<num>? bindPoseRotation;

  factory Bone.fromJson(Map<String, dynamic> json) => Bone(
      name: json["name"],
      binding: json["binding"],
      pivot: json["pivot"] == null
          ? [0, 0, 0]
          : List<num>.from(json["pivot"].map((x) => x)),
      cubes: json["cubes"] == null
          ? null
          : List<Cube>.from(json["cubes"].map((x) => Cube.fromJson(x))),
      parent: json["parent"],
      locators:
          json["locators"] == null ? null : Locators.fromJson(json["locators"]),
      mirror: json["mirror"],
      rotation: json["rotation"] == null
          ? [0, 0, 0]
          : List<num>.from(json["rotation"].map((x) => x)),
      bindPoseRotation: json["bind_pose_rotation"] == null
          ? [0, 0, 0]
          : List<num>.from(json["bind_pose_rotation"].map((x) => x)));

  Map<String, dynamic> toJson() {
    Map<String, dynamic> a = {
      "name": name,
      "binding": binding,
      "pivot": pivot == null ? null : List<dynamic>.from(pivot!.map((x) => x)),
      "cubes": cubes == null
          ? null
          : List<dynamic>.from(cubes!.map((x) => x.toJson())),
      "parent": parent,
      "locators": locators == null ? null : locators!.toJson(),
      "mirror": mirror,
      "rotation": rotation == null
          ? [0, 0, 0]
          : List<dynamic>.from(rotation!.map((x) => x)),
      "bind_pose_rotation": bindPoseRotation == null
          ? [0, 0, 0]
          : List<dynamic>.from(bindPoseRotation!.map((x) => x))
    };
    for (var entry in a.entries.toList()) {
      if (entry.value == null) {
        a.remove(entry.key);
      }
    }
    return a;
  }

  Map<String, dynamic> toJson2() {
    Map<String, dynamic> a = {
      "name": name,
      "binding": binding,
      "pivot": pivot == null ? null : List<dynamic>.from(pivot!.map((x) => x)),
      "cubes": cubes == null
          ? null
          : List<dynamic>.from(cubes!.map((x) => x.toJson())),
      "parent": parent,
      "locators": locators == null ? null : locators!.toJson(),
      "mirror": mirror,
      "rotation": rotation == null
          ? [0, 0, 0]
          : List<dynamic>.from(rotation!.map((x) => x)),
      "bind_pose_rotation": bindPoseRotation == null
          ? [0, 0, 0]
          : List<dynamic>.from(bindPoseRotation!.map((x) => x))
    };
    removeSomeKey(a);
    return a;
  }

  dynamic removeSomeKey(var components) {
    if (components is Map) {
      bool hasRotation = false;
      bool hasPivot = false;
      bool hasSize = false;
      if (components['rotation'] != null) {
        hasRotation = !(components['rotation'][0].toDouble() == 0.0 &&
            components['rotation'][1].toDouble() == 0.0 &&
            components['rotation'][2].toDouble() == 0.0);
      }
      if (components['pivot'] != null) {
        hasPivot = !(components['pivot'][0].toDouble() == 0.0 &&
            components['pivot'][1].toDouble() == 0.0 &&
            components['pivot'][2].toDouble() == 0.0);
      }
      if (components['size'] != null) {
        hasSize = !(components['size'][0].toDouble() == 0.0 &&
            components['size'][1].toDouble() == 0.0 &&
            components['size'][2].toDouble() == 0.0);
      }
      if (hasSize && (hasRotation || hasPivot)) {
      } else {
        for (var entry in components.entries.toList()) {
          if (entry.value == null) {
            components.remove(entry.key);
          } else if ((entry.key == "rotation" ||
                  entry.key == "pivot" ||
                  entry.key == "bind_pose_rotation") &&
              entry.value != null) {
            if (entry.value.length == 2) {
              if (entry.value[0].toDouble() == 0.0 &&
                  entry.value[1].toDouble() == 0.0) {
                components.remove(entry.key);
              }
            }
            if (entry.value.length == 3) {
              if (entry.value[0].toDouble() == 0.0 &&
                  entry.value[1].toDouble() == 0.0 &&
                  entry.value[2].toDouble() == 0.0) {
                components.remove(entry.key);
              }
            }
          } else {
            removeSomeKey(entry.value);
          }
        }
      }
    } else if (components is List) {
      for (dynamic entry in components) {
        removeSomeKey(entry);
      }
    }
  }
}

class Cube {
  Cube({
    this.origin,
    this.size,
    this.pivot,
    this.rotation,
    this.uv,
    this.inflate,
    this.mirror,
  });

  List<num>? origin;
  List<num>? pivot;
  List<num>? rotation;
  List<num>? size;
  dynamic uv;
  num? inflate;
  bool? mirror;
  bool? visible = true;

  int get width => (size![0] + size![2]).toInt() * 2;

  int get height => (size![1] + size![2]).toInt();

  factory Cube.fromJson(Map<String, dynamic> json) {
    dynamic uvresult(uv) {
      if (uv is List) {
        return List<num>.from(json["uv"].map((x) => x));
      } else if (uv is Map) {
        return json["uv"];
      } else {
        return null;
      }
    }

    return Cube(
      origin: List<num>.from(json["origin"].map((x) => x.toDouble())),
      size: List<num>.from(json["size"].map((x) => x.toDouble())),
      pivot: json["pivot"] != null
          ? List<num>.from(json["pivot"].map((x) => x.toDouble()))
          : [0, 0, 0],
      rotation: json["rotation"] != null
          ? List<num>.from(json["rotation"].map((x) => x.toDouble()))
          : [0, 0, 0],
      uv: uvresult(json["uv"]),
      inflate: json["inflate"] ?? 0,
      mirror: json["mirror"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> a = {
      "origin": List<dynamic>.from(origin!.map((x) => x)),
      "size": List<dynamic>.from(size!.map((x) => x)),
      "pivot": pivot == null ? null : List<dynamic>.from(pivot!.map((x) => x)),
      "rotation": List<dynamic>.from(rotation!.map((x) => x)),
      "uv": uv is List ? List<dynamic>.from(uv.map((x) => x)) : uv,
      "inflate": inflate ?? 0,
      "mirror": mirror,
    };
    for (var entry in a.entries.toList()) {
      if (entry.value == null) {
        a.remove(entry.key);
      }
      // if(["pivot","rotation"].contains(entry.key)){
      //   if(entry.value[0] == 0 && entry.value[1] == 0 && entry.value[2] == 0){
      //     a.remove(entry.key);
      //   }
      // }
    }
    return a;
  }
}

class Locators {
  List<num>? lead;
  List<num>? leftWing;
  List<num>? rightWing;
  List<num>? rightHand;
  List<num>? leftHand;
  List<num>? lead_hold;
  List<num>? held_item;
  List<num>? stun;

  Locators({
    this.lead,
    this.leftWing,
    this.rightWing,
    this.rightHand,
    this.leftHand,
    this.lead_hold,
    this.held_item,
    this.stun,
  });

  factory Locators.fromJson(Map<String, dynamic> json) => Locators(
        lead: json["lead"] == null
            ? null
            : List<num>.from(json["lead"].map((x) => x)),
        leftWing: json["left_wing"] == null
            ? null
            : List<num>.from(json["left_wing"].map((x) => x)),
        rightWing: json["right_wing"] == null
            ? null
            : List<num>.from(json["right_wing"].map((x) => x)),
        rightHand: json["right_hand"] == null
            ? null
            : List<num>.from(json["right_hand"].map((x) => x)),
        leftHand: json["left_hand"] == null
            ? null
            : List<num>.from(json["left_hand"].map((x) => x)),
        lead_hold: json["lead_hold"] == null
            ? null
            : List<num>.from(json["lead_hold"].map((x) => x)),
        held_item: json["held_item"] == null
            ? null
            : List<num>.from(json["held_item"].map((x) => x)),
        stun: json["stun"] == null
            ? null
            : List<num>.from(json["stun"].map((x) => x)),
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> a = {
      "lead": lead == null ? null : List<dynamic>.from(lead!.map((x) => x)),
      "left_wing":
          leftWing == null ? null : List<dynamic>.from(leftWing!.map((x) => x)),
      "right_wing": rightWing == null
          ? null
          : List<dynamic>.from(rightWing!.map((x) => x)),
      "right_hand": rightHand == null
          ? null
          : List<dynamic>.from(rightHand!.map((x) => x)),
      "left_hand":
          leftHand == null ? null : List<dynamic>.from(leftHand!.map((x) => x)),
      "lead_hold": lead_hold == null
          ? null
          : List<dynamic>.from(lead_hold!.map((x) => x)),
      "held_item": held_item == null
          ? null
          : List<dynamic>.from(held_item!.map((x) => x)),
      "stun": stun == null ? null : List<dynamic>.from(stun!.map((x) => x)),
    };
    for (var entry in a.entries.toList()) {
      if (entry.value == null) {
        a.remove(entry.key);
      }
    }
    return a;
  }
}
