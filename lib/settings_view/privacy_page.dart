import 'dart:developer';
import 'package:custom_progressbar/custom_progressbar.dart';
import 'package:flutter/material.dart';
import 'package:all_day_lesson_planner/domain/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late final WebViewController _controller;
  final _config = Config.instance;

  var isLoading = true;

  String get _cssCode =>
      ".docs-ml-promotion, #docs-ml-header-id { display: none !important; } .app-container { margin: 0 !important; }";

  String get _jsCode => """
      var style = document.createElement('style');
      style.type = "text/css";
      style.innerHTML = "$_cssCode";
      document.head.appendChild(style);
    """;

  @override
  void initState() {
    _initializeWebView();
    super.initState();
  }

  Future<void> _initializeWebView() async {
    // Load last URL or default URL
    final lastUrl = await _getLastUrl() ?? _config.link;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            log('Page started loading: $url');
          },
          onPageFinished: (String url) {
            controller.runJavaScript(_jsCode);
            log('Page finished loading: $url');

            _saveLastUrl(url);
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            log('''
              Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            log('Allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) async {
            log('URL change to ${change.url}');
            await _saveLastUrl(change.url!); // Save URL on every URL change
          },
        ),
      )
      ..loadRequest(Uri.parse(lastUrl));

    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }

    _controller = controller;
  }

  Future<void> _saveLastUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUrl', url);
  }

  Future<String?> _getLastUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: ProgressBar(
                  containerWidth: 100,
                  containerHeight: 100,
                  progressColor: Colors.black,
                  boxFit: BoxFit.contain,
                  iconHeight: 80,
                  iconWidth: 80,
                  imageFile: 'assets/images/icon.png',
                  progressHeight: 100,
                  progressWidth: 100,
                  progressStrokeWidth: 4,
                ),
              )
            : WebViewWidget(controller: _controller),
      ),
    );
  }
}
