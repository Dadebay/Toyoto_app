import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/strings.dart';
import '../theme/app_theme.dart';

/// Lets a parent screen drive the 3D viewer's paint color and camera angle
/// via JS hooks injected into the WebView (see [Car3DViewer._flyInAndHooksJs]).
class Car3DViewerController {
  final String paintMaterialName;
  WebViewController? _webView;

  Car3DViewerController({required this.paintMaterialName});

  void attach(WebViewController controller) {
    _webView = controller;
  }

  Future<void> setPaintColor(Color color) async {
    final webView = _webView;
    if (webView == null) return;
    try {
      await webView.runJavaScript(
        "window.setPaintColor && window.setPaintColor('$paintMaterialName', ${color.r}, ${color.g}, ${color.b});",
      );
    } catch (_) {
      // Ignore — JS bridge is best-effort, never blocks the demo.
    }
  }

  Future<void> setCameraOrbit(String orbit) async {
    final webView = _webView;
    if (webView == null) return;
    try {
      await webView.runJavaScript(
        "window.setCameraOrbit && window.setCameraOrbit('$orbit');",
      );
    } catch (_) {
      // Ignore.
    }
  }

  /// Moves the camera's look-at point, in the model's own coordinate space
  /// (meters), e.g. to swing it from the exterior to the cabin interior.
  Future<void> setCameraTarget(String target) async {
    final webView = _webView;
    if (webView == null) return;
    try {
      await webView.runJavaScript(
        "window.setCameraTarget && window.setCameraTarget('$target');",
      );
    } catch (_) {
      // Ignore.
    }
  }
}

/// Interactive 3D car preview. Drag to orbit the model in any direction and
/// pinch to zoom. Shows a loading indicator until the model has finished
/// downloading and rendering, so the user knows a model is on its way.
class Car3DViewer extends StatefulWidget {
  final String modelAsset;
  final bool autoRotate;
  final Car3DViewerController? controller;
  final String initialCameraOrbit;
  final String targetCameraOrbit;
  final String minVerticalOrbit;
  final String maxVerticalOrbit;
  final bool cameraControls;
  final String? paintMaterialName;
  final Color initialPaintColor;

  const Car3DViewer({
    super.key,
    required this.modelAsset,
    this.autoRotate = true,
    this.controller,
    this.initialCameraOrbit = '-90deg 85deg 180%',
    this.targetCameraOrbit = '25deg 78deg 105%',
    this.minVerticalOrbit = 'auto 20deg 8%',
    this.maxVerticalOrbit = 'auto 130deg auto',
    this.cameraControls = true,
    this.paintMaterialName,
    this.initialPaintColor = const Color(0xFFF2F3F5),
  });

  @override
  State<Car3DViewer> createState() => _Car3DViewerState();
}

class _Car3DViewerState extends State<Car3DViewer> {
  static const String _bridgeChannel = 'Car3DViewerBridge';

  bool _modelLoaded = false;

  /// Each viewer costs a platform WebView with its own WebGL context holding a
  /// 16-38MB model. Enough of them alive at once exhausts the platform GPU
  /// process (it crashes, and every viewer then renders blank), so screens that
  /// are alive but not visible mark their subtree inactive via [TickerMode] and
  /// we drop the WebView entirely until they come back.
  bool get _active => TickerMode.valuesOf(context).enabled;

  @override
  void didUpdateWidget(covariant Car3DViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modelAsset != widget.modelAsset) {
      setState(() => _modelLoaded = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Going inactive tears the WebView down, so the next mount reloads the
    // model and has to show the loading state again.
    if (!_active) _modelLoaded = false;
  }

  String get _initialPaintJs {
    final matName = widget.paintMaterialName;
    if (matName == null) return '';
    final color = widget.initialPaintColor;
    return "window.setPaintColor('$matName', ${color.r}, ${color.g}, ${color.b});";
  }

  String get _flyInAndHooksJs {
    return '''
customElements.whenDefined('model-viewer').then(() => {
  const mv = document.getElementById('car');
  if (!mv) return;
  function whenReady(cb) {
    if (mv.loaded) { cb(); return; }
    mv.addEventListener('load', cb, { once: true });
  }
  window.setPaintColor = function(matName, r, g, b) {
    whenReady(() => {
      const mat = mv.model && mv.model.materials.find((m) => m.name === matName);
      if (mat) mat.pbrMetallicRoughness.setBaseColorFactor([r, g, b, 1]);
    });
  };
  window.setCameraOrbit = function(orbit) {
    mv.cameraOrbit = orbit;
  };
  window.setCameraTarget = function(target) {
    mv.cameraTarget = target;
  };
  whenReady(() => {
    requestAnimationFrame(() => {
      mv.cameraOrbit = '${widget.targetCameraOrbit}';
    });
    $_initialPaintJs
    if (window.$_bridgeChannel) window.$_bridgeChannel.postMessage('loaded');
  });
});
''';
  }

  @override
  Widget build(BuildContext context) {
    if (!_active) return Container(color: AppColors.black);

    return Stack(
      fit: StackFit.expand,
      children: [
        ModelViewer(
          key: ValueKey(widget.modelAsset),
          id: 'car',
          backgroundColor: Colors.transparent,
          src: widget.modelAsset,
          alt: 'BMW 3D model',
          cameraControls: widget.cameraControls,
          disableZoom: false,
          disablePan: true,
          autoRotate: widget.autoRotate,
          autoRotateDelay: 1500,
          rotationPerSecond: '18deg',
          cameraOrbit: widget.initialCameraOrbit,
          minCameraOrbit: widget.minVerticalOrbit,
          maxCameraOrbit: widget.maxVerticalOrbit,
          interactionPrompt: InteractionPrompt.none,
          exposure: 1.1,
          shadowIntensity: 1.0,
          shadowSoftness: 0.9,
          environmentImage: 'neutral',
          relatedJs: _flyInAndHooksJs,
          onWebViewCreated: widget.controller?.attach,
          javascriptChannels: {
            JavascriptChannel(
              _bridgeChannel,
              onMessageReceived: (message) {
                if (message.message == 'loaded' && mounted) {
                  setState(() => _modelLoaded = true);
                }
              },
            ),
          },
        ),
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _modelLoaded ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: AppColors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.bmwBlue,
                      strokeWidth: 2.5,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('loading_model'),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
