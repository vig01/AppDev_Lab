import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firestore Calculator",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _fullExpression = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _fullExpression = "";
      } else if (buttonText == "<-") {
        if (_output.isNotEmpty) {
          _output = _output.substring(0, _output.length - 1);
          if (_output.isEmpty) _output = "0";
        }
      } else if (buttonText == "=") {
        try {
          _fullExpression = _output;
          _output = _calculate(_output);
          _saveToFirestore(_fullExpression, _output);
        } catch (e) {
          _output = "Error";
        }
      } else {
        if (_output == "0" || _output == "Error") {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  String _calculate(String exp) {
    exp = exp.replaceAll('×', '*').replaceAll('÷', '/');
    try {
      final parser = RegExp(r'(\d+|\+|\-|\*|\/)');
      final tokens = parser.allMatches(exp).map((m) => m.group(0)!).toList();

      double result = double.parse(tokens[0]);
      for (int i = 1; i < tokens.length; i += 2) {
        final op = tokens[i];
        final num = double.parse(tokens[i + 1]);
        if (op == '+') result += num;
        else if (op == '-') result -= num;
        else if (op == '*') result *= num;
        else if (op == '/') result /= num;
      }
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  Future<void> _saveToFirestore(String expression, String result) async {
    await FirebaseFirestore.instance.collection("calculations").add({
      "expression": expression,
      "result": result,
      "timestamp": Timestamp.now(),
    });
  }

  Future<void> _deleteAllHistory() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("calculations").get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  void _showHistory() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("calculations")
        .orderBy("timestamp", descending: true)
        .get();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("History"),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: snapshot.docs.isEmpty
              ? const Center(child: Text("No history found."))
              : ListView(
                  children: snapshot.docs.map((doc) {
                    return ListTile(
                      title: Text(doc["expression"]),
                      subtitle: Text("= ${doc["result"]}"),
                    );
                  }).toList(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _deleteAllHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("History deleted.")),
              );
            },
            child: const Text(
              "Delete All",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () => buttonText == "H"
              ? _showHistory()
              : _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color operatorColor = Colors.orange[600]!;
    final Color equalsColor = Colors.green[600]!;
    final Color numColor = Colors.blueGrey[100]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Calculator"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fullExpression.isEmpty ? " " : _fullExpression,
                    style:
                        const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  Text(
                    _output,
                    key: const Key('displayText'),
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('C', operatorColor),
                  _buildButton('H', operatorColor),
                  _buildButton('<-', operatorColor),
                  _buildButton('×', operatorColor),
                ],
              ),
              Row(
                children: [
                  _buildButton('7', numColor),
                  _buildButton('8', numColor),
                  _buildButton('9', numColor),
                  _buildButton('÷', operatorColor),
                ],
              ),
              Row(
                children: [
                  _buildButton('4', numColor),
                  _buildButton('5', numColor),
                  _buildButton('6', numColor),
                  _buildButton('-', operatorColor),
                ],
              ),
              Row(
                children: [
                  _buildButton('1', numColor),
                  _buildButton('2', numColor),
                  _buildButton('3', numColor),
                  _buildButton('+', operatorColor),
                ],
              ),
              Row(
                children: [
                  _buildButton('0', numColor),
                  _buildButton('=', equalsColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
