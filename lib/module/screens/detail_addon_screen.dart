import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tool_extract_community/module/models/addon_model.dart';
import 'dart:ui' as ui;

import '../components/const.dart';
import 'in_app_web_view.dart';

class DetailAddonScreen extends StatefulWidget {
  final AddonModels addonModel;

  const DetailAddonScreen({super.key, required this.addonModel});

  @override
  State<DetailAddonScreen> createState() => _DetailAddonScreenState();
}

class _DetailAddonScreenState extends State<DetailAddonScreen> {
  ValueNotifier<String> imgData = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Addon Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 400,
            child: screenViewModel(context, size),
          ),
          Text('addonName: ${widget.addonModel.addonName}'),
          Text('modelsRP: ${widget.addonModel.modelsRP.name}'),
          Row(
            children: [
              _buildTitleText("animations resource: "),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.addonModel.animationsRP!.length,
                    (index) => Text('${widget.addonModel.animationsRP![index].name}'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildTitleText("animation controllers resource: "),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.addonModel.animationControllersRP!.length,
                    (index) => Text('${widget.addonModel.animationControllersRP![index].name}'),
                  ),
                ),
              ),
            ],
          ),
          Text('textureRP: ${widget.addonModel.textureRP!.name}'),
        ],
      ),
    );
  }

  Widget screenViewModel(BuildContext context, ui.Size size) {
    return GestureDetector(
      onTap: () {
        try {
          final data = {
            'geoJson': json.decode(widget.addonModel.modelsRP.data!),
            'texture': json.decode(widget.addonModel.textureRP!.data!).cast<int>().toList(),
          };
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InAppWebViewPage(
                data: data,
              ),
            ),
          ).then((value) {
            if (value != null) {
              imgData.value = value;
            }
          });
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Model incorrect format or not found"),
                      const SizedBox(height: 10),
                      Text("$e"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"),
                    ),
                  ],
                );
              });
        }
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              SizedBox(
                height: size.height,
                child: ValueListenableBuilder<String>(
                  valueListenable: imgData,
                  builder: (context, value, child) {
                    return Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      height: 350,
                      width: size.width,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.3),
                        // gradient: kGradientItem,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: value.isEmpty
                          ? const SizedBox.shrink()
                          : Image.memory(
                              base64Decode(value),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  "Image incorrect format or not found",
                                );
                              },
                            ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Container(
                  width: 100,
                  height: 40,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: const Text(
                    "View in 3D",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
