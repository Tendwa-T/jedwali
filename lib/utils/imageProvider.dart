import 'package:flutter/painting.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

ImageProvider getSVGImage(String assetName) {
  return Svg(assetName);
}
