/// Pure calculation logic, kept separate from the UI so it can be unit-tested.
enum Operation { add, subtract, multiply, divide }

extension OperationSymbol on Operation {
  String get symbol => switch (this) {
    Operation.add => '+',
    Operation.subtract => '−',
    Operation.multiply => '×',
    Operation.divide => '÷',
  };
}

class Calculator {
  double? _storedValue;
  Operation? _pendingOperation;

  /// Text describing what has been entered so far, e.g. "12 +".
  String get pendingText => _storedValue == null || _pendingOperation == null
      ? ''
      : '${format(_storedValue!)} ${_pendingOperation!.symbol}';

  /// Called when an operator button is pressed with [input] in the field.
  /// If an operation is already pending, it is evaluated first (chaining:
  /// "2 + 3 ×" stores 5). Returns an error message or null.
  String? pressOperation(String input, Operation op) {
    final value = parse(input);
    if (value == null) {
      // Allow changing the operator before typing the second number.
      if (input.trim().isEmpty && _storedValue != null) {
        _pendingOperation = op;
        return null;
      }
      return 'Please enter a valid number';
    }
    if (_storedValue != null && _pendingOperation != null) {
      final result = _apply(_storedValue!, _pendingOperation!, value);
      if (result == null) {
        clear();
        return 'Cannot divide by zero';
      }
      _storedValue = result;
    } else {
      _storedValue = value;
    }
    _pendingOperation = op;
    return null;
  }

  /// Called when the result button is pressed. Returns the result text, or
  /// throws [CalculatorException] with a user-readable message.
  String pressEquals(String input) {
    if (_storedValue == null || _pendingOperation == null) {
      final value = parse(input);
      if (value == null) {
        throw CalculatorException('Please enter a valid number');
      }
      return format(value);
    }
    final value = parse(input);
    if (value == null) {
      throw CalculatorException('Please enter the second number');
    }
    final result = _apply(_storedValue!, _pendingOperation!, value);
    clear();
    if (result == null) throw CalculatorException('Cannot divide by zero');
    return format(result);
  }

  void clear() {
    _storedValue = null;
    _pendingOperation = null;
  }

  static double? _apply(double a, Operation op, double b) => switch (op) {
    Operation.add => a + b,
    Operation.subtract => a - b,
    Operation.multiply => a * b,
    Operation.divide => b == 0 ? null : a / b,
  };

  /// Accepts both "1.5" and the German "1,5".
  static double? parse(String input) {
    final text = input.trim().replaceAll(',', '.');
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  /// Shows whole numbers without ".0" and avoids long floating-point tails
  /// (0.1 + 0.2 shows as 0.3).
  static String format(double value) {
    if (value == value.roundToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }
    var text = value.toStringAsPrecision(12);
    if (text.contains('.') && !text.contains('e')) {
      text = text
          .replaceFirst(RegExp(r'0+$'), '')
          .replaceFirst(RegExp(r'\.$'), '');
    }
    return text;
  }
}

class CalculatorException implements Exception {
  CalculatorException(this.message);
  final String message;
  @override
  String toString() => message;
}
