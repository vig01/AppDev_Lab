import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  // 'output' is now the string displayed on the screen (e.g., "7 * 5")
  String output = "0";
  // '_input' is the number currently being typed
  String _input = "";
  double num1 = 0;
  double num2 = 0;
  String operand = "";

  // Helper to format numbers nicely (removes .0 from whole numbers)
  String _formatNumber(String numberStr) {
    if (numberStr.endsWith(".0")) {
      return numberStr.substring(0, numberStr.length - 2);
    }
    return numberStr;
  }

  // *** Completely rewritten button logic ***
  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        output = "0";
        _input = "";
        num1 = 0;
        num2 = 0;
        operand = "";
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/") {
        // If user presses another operator after a full equation (e.g. 7 + 5 *), calculate first
        if (operand.isNotEmpty && _input.isNotEmpty) {
          buttonPressed("=");
        }

        // Don't do anything if there's no number to operate on yet
        if (_input.isEmpty && operand.isEmpty) return;

        num1 = double.parse(output);
        operand = buttonText;
        output = "${_formatNumber(output)} $operand";
        _input = "";

      } else if (buttonText == "=") {
        if (operand.isEmpty || _input.isEmpty) {
          // Do nothing if the equation isn't complete
          return;
        }

        num2 = double.parse(_input);
        double result = 0.0;

        if (operand == "+") {
          result = num1 + num2;
        } else if (operand == "-") {
          result = num1 - num2;
        } else if (operand == "*") {
          result = num1 * num2;
        } else if (operand == "/") {
          result = num1 / num2;
        }

        String resultStr = result.toString();
        output = _formatNumber(resultStr);

        // Prepare for next calculation
        _input = output; // The result is the new starting number
        operand = "";
        num1 = 0;
        num2 = 0;

      } else { // A number or decimal is pressed
        if (buttonText == "." && _input.contains(".")) {
          // Prevent multiple decimals
          return;
        }

        // If the previous action was pressing "=", start a new calculation
        if (operand.isEmpty && _input == output) {
          _input = "";
        }

        _input += buttonText;
        if (operand.isEmpty) {
          output = _input;
        } else {
          output = "${_formatNumber(num1.toString())} $operand $_input";
        }
      }
    });
  }

  // Widget for building each button with custom colors
  Widget buildButton(String buttonText) {
    Color getButtonColor(String text) {
      if (text == "/" || text == "*" || text == "-" || text == "+") {
        return Colors.amber.shade700; // Operators
      }
      if (text == "C" || text == "=") {
        return Colors.blueGrey.shade300; // Controls
      }
      return Colors.blueGrey.shade700; // Numbers
    }

    Color getTextColor(String text) {
      if (text == "C" || text == "=") {
        return Colors.black87; // Dark text for light buttons
      }
      return Colors.white;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(24),
            backgroundColor: getButtonColor(buttonText),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: getTextColor(buttonText),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text("Flutter Calculator"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(
              output, // This now shows the full equation
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.blueGrey.shade600),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("/"),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("*"),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-"),
                ],
              ),
              Row(
                children: [
                  buildButton("."),
                  buildButton("0"),
                  buildButton("00"),
                  buildButton("+"),
                ],
              ),
              Row(
                children: [
                  buildButton("C"),
                  buildButton("="),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}