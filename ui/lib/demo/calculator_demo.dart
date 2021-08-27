import 'package:flutter/material.dart';
import 'package:ui/common/calculator.dart';

class CalculatorDemo extends StatefulWidget {
  const CalculatorDemo({Key? key}) : super(key: key);

  @override
  _CalculatorDemoState createState() => _CalculatorDemoState();
}

class _CalculatorDemoState extends State<CalculatorDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await showCalculator(context, initialValue: 32);
            print(result);
          },
          child: Text('Open Calculator'),
        ),
      ),
    );
  }
}
