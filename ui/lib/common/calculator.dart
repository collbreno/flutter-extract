import 'package:auto_size_text/auto_size_text.dart';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<double?> showCalculator(BuildContext context, {double? initialValue}) {
  return showDialog(context: context, builder: (ctx) => Calculator(initialValue: initialValue));
}

class Calculator extends StatefulWidget {
  final double? initialValue;

  const Calculator({Key? key, this.initialValue}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  static const _backBtn = 'Back';
  static const _clearBtn = 'CE';
  static const _minusBtn = '−';
  static const _plusBtn = '+';
  static const _timesBtn = '×';
  static const _divisionBtn = '÷';
  static const _equalsBtn = '=';
  final evaluator = const ExpressionEvaluator();

  final buttons = [
    '(',
    ')',
    _clearBtn,
    _backBtn,
    '7',
    '8',
    '9',
    _divisionBtn,
    '4',
    '5',
    '6',
    _timesBtn,
    '1',
    '2',
    '3',
    _minusBtn,
    '0',
    '.',
    _equalsBtn,
    _plusBtn
  ];

  final buttonSize = 70.0;

  late String _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _result = widget.initialValue?.toString() ?? '';
  }

  String _replaceSpecial(String text) {
    return text
        .replaceAll(_minusBtn, '-')
        .replaceAll(_plusBtn, '+')
        .replaceAll(_timesBtn, '*')
        .replaceAll(_divisionBtn, '/');
  }

  bool _evaluate() {
    try {
      final expression = Expression.tryParse(_replaceSpecial(_result));
      if (expression != null) {
        final result = evaluator.eval(expression, {});
        if (result is num && result.isFinite) {
          setState(() {
            _result = result.toString();
          });
          return true;
        }
      }
      setState(() {
        _error = 'Expressão inválida';
      });
      return false;
    } catch (e) {
      setState(() {
        _error = 'Expressão inválida';
      });
      return false;
    }
  }

  Widget _buildButton(String btn, Color textColor) {
    if (btn == _backBtn) {
      return Icon(
        Icons.backspace,
        color: textColor,
        size: 22,
      );
    }
    return Text(
      btn,
      style: TextStyle(
        fontFamily: 'Rubik',
        fontSize: 18,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _handleTap(String btn) {
    setState(() {
      _error = null;
    });
    if (btn == _backBtn) {
      if (_result.isNotEmpty) {
        setState(() {
          _result = _result.substring(0, _result.length - 1);
        });
      }
    } else if (btn == _clearBtn) {
      setState(() {
        _result = '';
      });
    } else if (btn == _equalsBtn) {
      _evaluate();
    } else {
      setState(() {
        _result += btn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 6),
      title: SizedBox(
        width: buttonSize * 4 - 24 * 3,
        height: 52,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onLongPress: () {
                HapticFeedback.vibrate();
                Clipboard.setData(ClipboardData(text: _result));
              },
              child: AutoSizeText(
                _result,
                maxLines: 1,
                style: TextStyle(fontSize: 24),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.right,
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Row(
        children: [0, 1, 2, 3]
            .map(
              (j) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [0, 1, 2, 3, 4]
                    .map(
                      (i) => Material(
                        color: j == 3 ? Colors.blue : Colors.white,
                        child: InkWell(
                          onTap: () {
                            _handleTap(buttons[i * 4 + j]);
                          },
                          child: Ink(
                            child: SizedBox(
                              height: buttonSize,
                              width: buttonSize,
                              child: Container(
                                alignment: Alignment.center,
                                // color: Colors.lightBlueAccent,
                                child: _buildButton(
                                    buttons[i * 4 + j], j == 3 ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_evaluate()) Navigator.pop(context, double.parse(_result));
          },
          child: Text('Ok'),
        ),
      ],
    );
  }
}
