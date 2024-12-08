import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tool_extract_community/module/screens/detail_addon_screen.dart';
import '../providers/upload_community_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  late BuildContext context;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var provider = Provider.of<UploadCommunityProvider>(context, listen: false);
    var watchProvider = context.watch<UploadCommunityProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tool Extract Addon Community"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  color: Colors.grey,
                  child: const Text("Pick Addon"),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("List Addon extracted: "),
            ),
          ),
          _buildBodyWidget(provider),
          MaterialButton(
            onPressed: () {
              provider.downloadZip();
            },
            color: Colors.grey,
            child: const Text("Download File"),
          ),
        ],
      ),
    );
    /*return CustomBackground(
      appBar: const CustomAppBar(
        title: "Công cụ tách Addon",
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.pickAddon();
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: kGradientButton,
                            ),
                            alignment: Alignment.center,
                            child: const Text("Chọn Addon"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: kGradientButton,
                          ),
                          alignment: Alignment.center,
                          child: const Text("Xóa toàn bộ"),
                        ),
                      ],
                    ),
                    const Text("Danh such file đã chọn: "),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...watchProvider.filesPicked.map(
                              (e) => Container(
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: kGradientItem,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e.name,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await provider.extractAddon();
                        _buildDialogFinish(watchProvider);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: kGradientButton,
                        ),
                        alignment: Alignment.center,
                        child: const Text("Bắt đầu thôi"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
              animation: provider.isLoading,
              builder: (context, child) {
                ValueNotifier<bool> isHideButton = ValueNotifier(false);
                if (provider.isLoading.value == false) return const SizedBox.shrink();
                return Container(
                  color: Colors.black.withOpacity(.3),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      height: 200,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(.5), borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              "assets/animations/cute_loading.gif",
                            ),
                          ),
                          const Text("Em đang xử lý!! Chờ xíu nhaaaa...."),
                          const SizedBox(height: 8),
                          AnimatedBuilder(
                            animation: isHideButton,
                            builder: (context, child) {
                              Timer(const Duration(seconds: 5), () {
                                isHideButton.value = true;
                              });
                              return Visibility(
                                visible: isHideButton.value,
                                child: MaterialButton(
                                  onPressed: () {
                                    provider.isLoading.value = false;
                                  },
                                  color: Colors.grey,
                                  child: const Text(
                                    "Hủy",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );*/
  }

  Future<void> _buildDialogError(watchProvider) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(.8),
          title: const Text(
            "Something went wrong:",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...watchProvider.errorFileName.map(
                  (e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name ?? ""),
                      Text("  ${e.data}"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text("-" * 40),
                const Text("Ôi không, những addon trên đã gặp sự cố.\nLiên hệ CầnCần để được xử lý."),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyWidget(provider) {
    return Expanded(
      child: ListView.separated(
        itemCount: provider.listAddonExtracted.length,
        itemBuilder: (context, index) {
          var element = provider.listAddonExtracted[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetailAddonScreen(addonModel: element),
                  ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(element.addonName ?? ""),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
      ),
    );
  }

// Future<void> _buildDialogFinish(UploadCommunityProvider watchProvider) async {
//   return await showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         backgroundColor: Colors.black.withOpacity(.8),
//         title: const Text(
//           "Success:",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                 "assets/animations/done_ani.gif",
//                 height: 150,
//               ),
//               Text("Em đã xử lý xong.\nFile được lưu tại ${watchProvider.folderPathExtracted}"),
//               const Divider(),
//               if (watchProvider.errorFileName.isNotEmpty)
//                 SizedBox(
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Có một số lỗi cần xem lại: ",
//                         style: textStyleDefault.copyWith(
//                           color: Colors.red,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       // ...watchProvider.errorFileName.map(
//                       //   (e) => Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.start,
//                       //     children: [
//                       //       Text("- ${e.name}"),
//                       //       Text("  ${e.data}"),
//                       //     ],
//                       //   ),
//                       // ),
//                       const SizedBox(height: 8),
//                       const Divider(),
//                       const Text("Liên hệ CầnCần để được xử lý."),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         actions: [
//           MaterialButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text(
//               "OK",
//               style: textStyleDefault,
//             ),
//           ),
//           MaterialButton(
//             onPressed: () async {
//               // final Uri uri = Uri.file(watchProvider.folderPathExtracted);
//               // if (await canLaunchUrl(uri)) {
//               //   await launchUrl(uri);
//               // } else {
//               //   final snackBar = SnackBar(
//               //     content: Text('Không thể mở thư mục: ${watchProvider.folderPathExtracted}!!'),
//               //     duration: const Duration(seconds: 2),
//               //   );
//               //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               // }
//             },
//             child: Text(
//               "Đi tới file",
//               style: textStyleDefault,
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
}
