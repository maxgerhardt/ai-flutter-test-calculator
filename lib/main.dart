import 'package:material_ui/material_ui.dart';

import 'calculator_view.dart';
import 'designs.dart';
import 'gallery.dart';

/// The design the app uses. Change to any `id` from designs.dart.
const activeDesignId = 'lcd';

/// Build with `--dart-define=GALLERY=true` to show all designs side by side.
const showGallery = bool.fromEnvironment('GALLERY');

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key, this.gallery = showGallery});

  final bool gallery;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: gallery ? 'Calculator designs' : 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: gallery
          ? const GalleryPage()
          : Scaffold(body: CalculatorView(design: designById(activeDesignId))),
    );
  }
}
