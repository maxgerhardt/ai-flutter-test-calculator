import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Set to false in tests so no fonts are downloaded.
bool useGoogleFonts = true;

TextStyle designFont(String? family, TextStyle style) {
  if (family == null || !useGoogleFonts) return style;
  return GoogleFonts.getFont(family, textStyle: style);
}

enum ButtonLayout {
  /// All four operators in one row, wide result button below.
  row,

  /// Operators in a 2×2 grid, wide result button below.
  grid,
}

/// Everything that defines how the calculator looks. The behaviour is the
/// same for every design — only the visuals change.
class CalculatorDesign {
  const CalculatorDesign({
    required this.id,
    required this.name,
    required this.tagline,
    required this.brightness,
    required this.background,
    this.backgroundGradient,
    required this.titleColor,
    this.titleFont,
    this.titleAlign = TextAlign.left,
    required this.displayBackground,
    required this.displayText,
    required this.pendingText,
    this.displayBorder = BorderSide.none,
    this.displayShadow = const [],
    required this.displayRadius,
    this.displayFont,
    this.displaySize = 40,
    this.displayWeight = FontWeight.w400,
    required this.operatorBackground,
    required this.operatorText,
    this.operatorBorder = BorderSide.none,
    required this.equalsBackground,
    required this.equalsText,
    this.equalsBorder = BorderSide.none,
    this.buttonShadow = const [],
    required this.buttonRadius,
    this.buttonHeight = 64,
    this.buttonFont,
    this.buttonSize = 26,
    this.gap = 12,
    this.layout = ButtonLayout.row,
    required this.errorColor,
  });

  final String id;
  final String name;
  final String tagline;
  final Brightness brightness;

  final Color background;
  final Gradient? backgroundGradient;

  final Color titleColor;
  final String? titleFont;
  final TextAlign titleAlign;

  final Color displayBackground;
  final Color displayText;
  final Color pendingText;
  final BorderSide displayBorder;
  final List<BoxShadow> displayShadow;
  final double displayRadius;
  final String? displayFont;
  final double displaySize;
  final FontWeight displayWeight;

  final Color operatorBackground;
  final Color operatorText;
  final BorderSide operatorBorder;
  final Color equalsBackground;
  final Color equalsText;
  final BorderSide equalsBorder;
  final List<BoxShadow> buttonShadow;
  final double buttonRadius;
  final double buttonHeight;
  final String? buttonFont;
  final double buttonSize;
  final double gap;
  final ButtonLayout layout;

  final Color errorColor;
}

const designs = <CalculatorDesign>[
  CalculatorDesign(
    id: 'classic',
    name: 'Classic Material',
    tagline: 'The current look: calm indigo, standard Android style.',
    brightness: Brightness.light,
    background: Color(0xFFFBF8FF),
    titleColor: Color(0xFF1B1B21),
    displayBackground: Color(0x00000000),
    displayText: Color(0xFF1B1B21),
    pendingText: Color(0xFF5F5E6A),
    displayBorder: BorderSide(color: Color(0xFF4F5B92), width: 2),
    displayRadius: 6,
    operatorBackground: Color(0xFFDFE0F9),
    operatorText: Color(0xFF1B1B21),
    equalsBackground: Color(0xFF4F5B92),
    equalsText: Color(0xFFFFFFFF),
    buttonRadius: 32,
    errorColor: Color(0xFFBA1A1A),
  ),
  CalculatorDesign(
    id: 'midnight',
    name: 'Midnight Orange',
    tagline: 'Pure black, huge thin digits, glowing orange result key.',
    brightness: Brightness.dark,
    background: Color(0xFF000000),
    titleColor: Color(0xFFFFFFFF),
    titleFont: 'Inter',
    displayBackground: Color(0x00000000),
    displayText: Color(0xFFFFFFFF),
    pendingText: Color(0xFF8E8E93),
    displayRadius: 0,
    displayFont: 'Inter',
    displaySize: 64,
    displayWeight: FontWeight.w300,
    operatorBackground: Color(0xFF333333),
    operatorText: Color(0xFFFFFFFF),
    equalsBackground: Color(0xFFFF9F0A),
    equalsText: Color(0xFFFFFFFF),
    buttonRadius: 999,
    buttonHeight: 76,
    buttonFont: 'Inter',
    buttonSize: 32,
    layout: ButtonLayout.grid,
    errorColor: Color(0xFFFF453A),
  ),
  CalculatorDesign(
    id: 'lcd',
    name: 'Retro LCD',
    tagline: '80s desk calculator: green LCD, chunky keys with depth.',
    brightness: Brightness.light,
    background: Color(0xFFD9D3C3),
    titleColor: Color(0xFF3A3A3A),
    titleFont: 'Space Mono',
    displayBackground: Color(0xFF9DAE7C),
    displayText: Color(0xFF1F2A17),
    pendingText: Color(0xFF465238),
    displayBorder: BorderSide(color: Color(0xFF4A4A4A), width: 5),
    displayRadius: 8,
    displayFont: 'VT323',
    displaySize: 56,
    operatorBackground: Color(0xFF3B3B3B),
    operatorText: Color(0xFFF1EDE4),
    equalsBackground: Color(0xFFC9473B),
    equalsText: Color(0xFFFFFFFF),
    buttonShadow: [BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(0, 5))],
    buttonRadius: 8,
    buttonFont: 'Space Mono',
    buttonSize: 32,
    layout: ButtonLayout.grid,
    errorColor: Color(0xFF9B1C12),
  ),
  CalculatorDesign(
    id: 'neon',
    name: 'Neon Night',
    tagline: 'Synthwave purple with cyan and magenta glow.',
    brightness: Brightness.dark,
    background: Color(0xFF14081F),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1A0B2E), Color(0xFF3B0F5C)],
    ),
    titleColor: Color(0xFF00F0FF),
    titleFont: 'Orbitron',
    displayBackground: Color(0xFF0D0518),
    displayText: Color(0xFF00F0FF),
    pendingText: Color(0xFFB47CFF),
    displayBorder: BorderSide(color: Color(0xFF00F0FF), width: 2),
    displayShadow: [BoxShadow(color: Color(0x9900F0FF), blurRadius: 18)],
    displayRadius: 14,
    displayFont: 'Audiowide',
    displaySize: 40,
    operatorBackground: Color(0xFF1A0B2E),
    operatorText: Color(0xFFFF2BD6),
    operatorBorder: BorderSide(color: Color(0xFFFF2BD6), width: 2),
    equalsBackground: Color(0xFFFF2BD6),
    equalsText: Color(0xFF14081F),
    equalsBorder: BorderSide(color: Color(0xFFFF2BD6), width: 2),
    buttonShadow: [BoxShadow(color: Color(0x66FF2BD6), blurRadius: 14)],
    buttonRadius: 14,
    buttonFont: 'Audiowide',
    buttonSize: 30,
    errorColor: Color(0xFFFF6B6B),
  ),
  CalculatorDesign(
    id: 'paper',
    name: 'Paper Minimal',
    tagline: 'Editorial and quiet: serif digits, thin ink lines.',
    brightness: Brightness.light,
    background: Color(0xFFF7F3EA),
    titleColor: Color(0xFF1F1D1A),
    titleFont: 'Playfair Display',
    titleAlign: TextAlign.center,
    displayBackground: Color(0x00000000),
    displayText: Color(0xFF1F1D1A),
    pendingText: Color(0xFF7A746A),
    displayBorder: BorderSide(color: Color(0xFF1F1D1A), width: 1.5),
    displayRadius: 0,
    displayFont: 'Playfair Display',
    displaySize: 52,
    displayWeight: FontWeight.w500,
    operatorBackground: Color(0x00000000),
    operatorText: Color(0xFF1F1D1A),
    operatorBorder: BorderSide(color: Color(0xFF1F1D1A), width: 1.5),
    equalsBackground: Color(0xFF1F1D1A),
    equalsText: Color(0xFFF7F3EA),
    buttonRadius: 0,
    buttonHeight: 60,
    buttonFont: 'IBM Plex Mono',
    buttonSize: 24,
    gap: 10,
    errorColor: Color(0xFFA4161A),
  ),
  CalculatorDesign(
    id: 'brutal',
    name: 'Bold Brutalist',
    tagline: 'Loud yellow, thick black outlines, hard offset shadows.',
    brightness: Brightness.light,
    background: Color(0xFFFFE14D),
    titleColor: Color(0xFF000000),
    titleFont: 'Archivo Black',
    displayBackground: Color(0xFFFFFFFF),
    displayText: Color(0xFF000000),
    pendingText: Color(0xFF3A3A3A),
    displayBorder: BorderSide(color: Color(0xFF000000), width: 3),
    displayShadow: [BoxShadow(color: Color(0xFF000000), offset: Offset(6, 6))],
    displayRadius: 0,
    displayFont: 'Archivo Black',
    displaySize: 44,
    operatorBackground: Color(0xFFFFFFFF),
    operatorText: Color(0xFF000000),
    operatorBorder: BorderSide(color: Color(0xFF000000), width: 3),
    equalsBackground: Color(0xFFFF5C39),
    equalsText: Color(0xFF000000),
    equalsBorder: BorderSide(color: Color(0xFF000000), width: 3),
    buttonShadow: [BoxShadow(color: Color(0xFF000000), offset: Offset(4, 4))],
    buttonRadius: 0,
    buttonFont: 'Archivo Black',
    layout: ButtonLayout.grid,
    errorColor: Color(0xFFB00020),
  ),
  CalculatorDesign(
    id: 'soft',
    name: 'Soft Pastel',
    tagline: 'Neumorphic: keys pressed out of a soft blue-grey surface.',
    brightness: Brightness.light,
    background: Color(0xFFE4E9F1),
    titleColor: Color(0xFF3D4A5C),
    titleFont: 'Nunito',
    displayBackground: Color(0xFFE4E9F1),
    displayText: Color(0xFF3D4A5C),
    pendingText: Color(0xFF8492A6),
    displayShadow: [
      BoxShadow(
        color: Color(0xFFFFFFFF),
        offset: Offset(-6, -6),
        blurRadius: 14,
      ),
      BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(6, 6), blurRadius: 14),
    ],
    displayRadius: 24,
    displayFont: 'Nunito',
    displaySize: 44,
    displayWeight: FontWeight.w700,
    operatorBackground: Color(0xFFE4E9F1),
    operatorText: Color(0xFF6C7A93),
    equalsBackground: Color(0xFF7C9CF2),
    equalsText: Color(0xFFFFFFFF),
    buttonShadow: [
      BoxShadow(
        color: Color(0xFFFFFFFF),
        offset: Offset(-4, -4),
        blurRadius: 10,
      ),
      BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(4, 4), blurRadius: 10),
    ],
    buttonRadius: 22,
    buttonFont: 'Nunito',
    errorColor: Color(0xFFD64545),
  ),
];

CalculatorDesign designById(String id) =>
    designs.firstWhere((d) => d.id == id, orElse: () => designs.first);
