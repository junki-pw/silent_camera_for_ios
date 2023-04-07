import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'camera/camera_screen.dart';

void main() {
  runApp(ProviderScope(child: MaterialApp(home: CameraScreen())));
}
