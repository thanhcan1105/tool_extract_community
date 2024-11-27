import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/custom_appbar.dart';
import '../components/custom_background.dart';

class InAppWebViewPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const InAppWebViewPage({super.key, required this.data});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  static final WebUri htmlFileURI = WebUri.uri(Uri.base.replace(
      path:
          "assets/assets/blockbench/index.html")); // note the double `assets/`, that's not a typo, it was actually needed

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {

    // html.window.onMessage.listen((event) {
    //   print("message from web: ${event.data}");
    // });


    html.window.onMessage.listen((event) {
      final data = event.data;
      if (data['type'] == 'image') {
        var repo  = data['text'].toString().replaceAll("result: data:image/png;base64,",  "");
        Navigator.pop(context, repo);
      }
    });

    super.initState();
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  Future<void> _initModel() async {
    final geoJson = widget.data['geoJson'];
    final texture = widget.data['texture'];

    final data = {
      'data': [
        {
          "file_name": "model.json",
          "type": "model",
          "data": geoJson,
        },
        {
          "file_name": "data.png",
          "type": "texture",
          "data": base64Encode(texture),
        },
      ]
    };
    webViewController!.evaluateJavascript(
        source: "window.loadModelFromApp(${jsonEncode(data)})");
  }


  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: const CustomAppBar(
        title: "BlockBench WebView",
        isShowLeading: true,
        // actionsTabBar: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.screenshot),
        //     onPressed: () async {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: htmlFileURI),
                    initialSettings: settings,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) async {
                      _initModel();
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunchUrl(uri)) {
                          // Launch the App
                          await launchUrl(
                            uri,
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      await controller.injectJavascriptFileFromUrl(
                          urlFile: WebUri(
                              'https://code.jquery.com/jquery-3.3.1.min.js'),
                          scriptHtmlTagAttributes: ScriptHtmlTagAttributes(
                              id: 'jquery',
                              onLoad: () {
                                print("jQuery loaded and ready to be used!");
                              },
                              onError: () {
                                print(
                                    "jQuery not available! Some error occurred.");
                              }));
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                ],
              ),
            ),
            // ButtonBar(
            //   alignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     ElevatedButton(
            //       child: const Icon(Icons.arrow_back),
            //       onPressed: () {
            //         webViewController?.goBack();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: const Icon(Icons.arrow_forward),
            //       onPressed: () {
            //         webViewController?.goForward();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: const Icon(Icons.refresh),
            //       onPressed: () {
            //         webViewController?.reload();
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
