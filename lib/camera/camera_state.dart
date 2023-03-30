import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_state.freezed.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    @Default([]) List<String> localPaths,
    CameraDescription? camera,
    CameraController? controller,
  }) = _CameraState;
}
