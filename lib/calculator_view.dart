import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'calculator.dart';
import 'designs.dart';

/// The complete calculator screen, drawn in the given [design].
class CalculatorView extends StatefulWidget {
  const CalculatorView({
    super.key,
    required this.design,
    this.autofocus = true,
  });

  final CalculatorDesign design;
  final bool autofocus;

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _calculator = Calculator();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onOperation(Operation op) {
    setState(() {
      _error = _calculator.pressOperation(_controller.text, op);
      if (_error == null) _controller.clear();
    });
    _focusNode.requestFocus();
  }

  void _onEquals() {
    setState(() {
      try {
        _controller.text = _calculator.pressEquals(_controller.text);
        _error = null;
      } on CalculatorException catch (e) {
        _error = e.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.design;
    final displayStyle = designFont(
      d.displayFont,
      TextStyle(
        fontSize: d.displaySize,
        fontWeight: d.displayWeight,
        color: d.displayText,
      ),
    );
    final buttonStyle = designFont(
      d.buttonFont,
      TextStyle(fontSize: d.buttonSize, fontWeight: FontWeight.w600),
    );
    final titleStyle = designFont(
      d.titleFont,
      TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: d.titleColor),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: d.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Theme(
        data: ThemeData(
          brightness: d.brightness,
          useMaterial3: true,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: d.displayText,
            selectionColor: d.displayText.withValues(alpha: 0.3),
            selectionHandleColor: d.displayText,
          ),
        ),
        // Expand so the background always fills the screen, even though the
        // scrollable content inside may be shorter.
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: d.backgroundGradient == null ? d.background : null,
            gradient: d.backgroundGradient,
          ),
          child: SafeArea(
            // Scrollable so the layout never overflows when the on-screen
            // keyboard leaves little room (small phones, tall designs).
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Calculator',
                    textAlign: d.titleAlign,
                    style: titleStyle,
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: d.displayBackground,
                      border: Border.fromBorderSide(d.displayBorder),
                      borderRadius: BorderRadius.circular(d.displayRadius),
                      boxShadow: d.displayShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _calculator.pendingText,
                          key: const Key('pending'),
                          style: displayStyle.copyWith(
                            fontSize: d.displaySize * 0.4,
                            color: d.pendingText,
                          ),
                        ),
                        TextField(
                          key: const Key('numberField'),
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: widget.autofocus,
                          textAlign: TextAlign.right,
                          style: displayStyle,
                          cursorColor: d.displayText,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            hintText: '0',
                            hintStyle: displayStyle.copyWith(
                              color: d.displayText.withValues(alpha: 0.35),
                            ),
                          ),
                          onSubmitted: (_) => _onEquals(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 22,
                    child: Text(
                      _error ?? '',
                      key: const Key('error'),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: d.errorColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._buttons(d, buttonStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buttons(CalculatorDesign d, TextStyle style) {
    Widget op(Operation o) => _DesignButton(
      key: Key('op_${o.name}'),
      design: d,
      label: o.symbol,
      background: d.operatorBackground,
      foreground: d.operatorText,
      border: d.operatorBorder,
      style: style,
      onTap: () => _onOperation(o),
    );
    final equals = _DesignButton(
      key: const Key('equals'),
      design: d,
      label: '=',
      background: d.equalsBackground,
      foreground: d.equalsText,
      border: d.equalsBorder,
      style: style,
      onTap: _onEquals,
    );
    Widget row(List<Widget> children) => Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: d.gap),
          Expanded(child: children[i]),
        ],
      ],
    );
    final ops = Operation.values.map(op).toList();
    final gap = SizedBox(height: d.gap);
    return switch (d.layout) {
      ButtonLayout.row => [row(ops), gap, equals],
      ButtonLayout.grid => [
        row(ops.sublist(0, 2)),
        gap,
        row(ops.sublist(2)),
        gap,
        equals,
      ],
    };
  }
}

class _DesignButton extends StatelessWidget {
  const _DesignButton({
    super.key,
    required this.design,
    required this.label,
    required this.background,
    required this.foreground,
    required this.border,
    required this.style,
    required this.onTap,
  });

  final CalculatorDesign design;
  final String label;
  final Color background;
  final Color foreground;
  final BorderSide border;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(design.buttonRadius);
    return Container(
      height: design.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: design.buttonShadow,
      ),
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(borderRadius: radius, side: border),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(label, style: style.copyWith(color: foreground)),
          ),
        ),
      ),
    );
  }
}
