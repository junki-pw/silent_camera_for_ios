import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:silent_camera_for_ios/camera/camera_controller.dart' as c;

import 'package:image/image.dart' as imglib;

class CameraScreen extends ConsumerWidget {
  const CameraScreen({Key? key}) : super(key: key);

  /// -----------  重要  -----------
  /// iOSの実機で必ずテストするようにする
  /// Androidではエラーになる
  /// ってか、Androidは無音設定できるからそもそもイラン

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(c.cameraProvider);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          func(state.controller!, context);
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
      body: ListView(
        children: [
          if (state.controller != null) CameraPreview(state.controller!),
        ],
      ),
    );
  }

  func(CameraController controller, BuildContext context) async {
    controller.startImageStream((CameraImage cameraImage) async {
      /// 1回で停止
      /// 停止しないと一生ぶん回ってる
      await controller.stopImageStream();

      /// CameraImage を Image に変換(?)
      final imglib.Image image = imglib.Image.fromBytes(
        width: cameraImage.width,
        height: cameraImage.height,
        bytes: cameraImage.planes.first.bytes.buffer,
        format: imglib.Format.uint8,

        /// デフォルト：3
        /// 3の場合、よく分からない表示になってしまう
        numChannels: 4,

        /// デフォルト：rgba（ ← 青色になっている原因）
        /// 必ずbgraに変更する
        order: imglib.ChannelOrder.bgra,
      );

      /// Image を png に変換
      imglib.PngEncoder pngEncoder = imglib.PngEncoder();
      Uint8List png = pngEncoder.encode(image);

      /// 画面遷移
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => Camera2Screen(png: png)));
    });
  }
}

class Camera2Screen extends StatelessWidget {
  const Camera2Screen({
    Key? key,
    required this.png,
  }) : super(key: key);
  final Uint8List png;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Image.memory(png),
    );
  }
}
