import 'package:flutter/material.dart';

final kGradientBackground = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.blueGrey.withOpacity(.5),
    Colors.blueGrey.withOpacity(.7),
    Colors.blueGrey.withOpacity(.3),
  ],
);

final kGradientItem = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white.withOpacity(.7),
    Colors.white.withOpacity(.6),
    Colors.white.withOpacity(.7),
  ],
);

final kGradientItemSelected = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.blue.shade100.withOpacity(.7),
    Colors.blue.shade100.withOpacity(.6),
    Colors.blue.shade100.withOpacity(.7),
  ],
);

final kGradientButton = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.blue.shade200.withOpacity(.7),
    Colors.blue.shade200.withOpacity(.6),
    Colors.blue.shade200.withOpacity(.7),
  ],
);

const String kDefaultBackground = 'assets/backgrounds/tool_bg.png';
const String icImportFile = 'assets/icons/ic_import_file.png';

String galleryBox = 'galleryBox';
String mySkinsBox = 'mySkinsBox';


String emptyImg64x64 = 'iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAQAAAAAYLlVAAAAOUlEQVR42u3OIQEAAAACIP1/2hkWWEBzVgEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAYF3YDicAEE8VTiYAAAAAElFTkSuQmCC';


final List defaultCateVehicle = [
  {
    'id': '664b123afe437656872f3222',
    'name': 'All',
    'thumbnail': 'string',
    'category': 'all',
    'additionalProp1': {}
  },
  {
    'id': '664b1240fe437656872f3223',
    'name': 'Car',
    'thumbnail': 'string',
    'category': 'car',
    'additionalProp1': {}
  },
  {
    'id': '664b125bfe437656872f3225',
    'name': 'Truck',
    'thumbnail': 'string',
    'category': 'truck',
    'additionalProp1': {}
  },
  {
    'id': '664b1264fe437656872f3226',
    'name': 'Plane',
    'thumbnail': 'string',
    'category': 'plane',
    'additionalProp1': {}
  },
  {
    'id': '664b126cfe437656872f3227',
    'name': 'Bike',
    'thumbnail': 'string',
    'category': 'bike',
    'additionalProp1': {}
  },
  {
    'id': '664b1272fe437656872f3228',
    'name': 'Motor',
    'thumbnail': 'string',
    'category': 'motor',
    'additionalProp1': {}
  },
  {
    'id': '664b1279fe437656872f3229',
    'name': 'Boat',
    'thumbnail': 'string',
    'category': 'boat',
    'additionalProp1': {}
  },
  {
    'id': '664b1290fe437656872f322a',
    'name': 'Mech',
    'thumbnail': 'string',
    'category': 'mech',
    'additionalProp1': {}
  },
  {
    'id': '664b129afe437656872f322b',
    'name': 'Tank',
    'thumbnail': 'string',
    'category': 'tank',
    'additionalProp1': {}
  },
  {
    'id': '664b129efe437656872f322c',
    'name': 'Other',
    'thumbnail': 'string',
    'category': 'other',
    'additionalProp1': {}
  }
];