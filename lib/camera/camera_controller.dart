import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:camera/camera.dart' as camera;

import 'camera_state.dart';

final cameraProvider = StateNotifierProvider<CameraController, CameraState>(
  (ref) => CameraController(ref: ref),
);

class CameraController extends StateNotifier<CameraState> {
  CameraController({
    required this.ref,
  }) : super(const CameraState()) {
    _controllerInitialize();
  }

  final Ref ref;

  /// コントローラーの初期化
  _controllerInitialize() async {
    final cameras = await camera.availableCameras();
    final firstCamera = cameras.first;
    print('firstCamera: $firstCamera');

    final controller = camera.CameraController(
      firstCamera, // カメラを指定
      camera.ResolutionPreset.medium, // 解像度を定義
    );
    print('テスト1');
    await controller.initialize();
    print('テスト2');

    ref.onDispose(() {
      state.controller?.dispose();
    });

    state = state.copyWith(
      controller: controller,
    );
  }
}
