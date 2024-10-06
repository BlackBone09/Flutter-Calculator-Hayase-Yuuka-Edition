import 'package:yuukacalculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/hayase_yuuka.jpg'),
              fit: BoxFit.cover,
              alignment: const Alignment(0.4, 0.0),
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.darken,
              ),
            ),
          ),
          constraints: const BoxConstraints(),
          child: Column(
            children: [
              // Display Section
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Text(
                      "$number1$operand$number2".isEmpty
                          ? "0"
                          : "$number1$operand$number2",
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 236, 161, 255),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),

              // Keypad Section
              Wrap(
                children: Btn.buttonValues
                    .map(
                      (value) => SizedBox(
                          width: value == Btn.n0
                              ? screenSize.width / 2
                              : screenSize.width / 4,
                          height: screenSize.width / 4,
                          child: buildButton(value)),
                    )
                    .toList(),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Footer Text
                    const Column(
                      children: [
                        Text(
                          'Hayase Yuuka Themed Simple Calculator',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        Text(
                          'Made by : Blackbone',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/yuuka_smol.png',
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.purple[500]!, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: [
              Btn.multiply,
              Btn.divide,
              Btn.subtract,
              Btn.add,
              Btn.del,
              Btn.clr,
              Btn.per
            ].contains(value)
                ? Colors.purple[700]!.withOpacity(0.5)
                : value == Btn.calculate
                    ? const Color.fromARGB(255, 179, 0, 255)
                    : Colors.purple[700]!.withOpacity(0.2),
            child: InkWell(
              onTap: () => onBtnTap(value),
              splashColor: Colors.purpleAccent.withOpacity(0.5),
              child: Center(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 236, 161, 255),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// ##############
  void performCalculation() {
    setState(() {
      if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

      final double num1 = double.parse(number1);
      final double num2 = double.parse(number2);

      double result = 0.0;
      switch (operand) {
        case Btn.add:
          result = num1 + num2;
          break;
        case Btn.subtract:
          result = num1 - num2;
          break;
        case Btn.multiply:
          result = num1 * num2;
          break;
        case Btn.divide:
          result = num1 / num2;
          break;
        default:
      }

      if (result % 1 == 0) {
        // If result is a whole number, remove the decimal part
        number1 = result.toInt().toString();
      } else {
        // If result is a floating-point number, keep the decimals
        number1 =
            result.toStringAsFixed(2); // Or adjust the number of decimal places
      }

      operand = "";
      number2 = "";

      // Set the result flag to true
      isResultDisplayed = true;
    });
  }

// ########
  void onBtnTap(String value) {
    // Handle delete, clear, percentage, and equals separately
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      performCalculation();
      return;
    }

    // Handle negative number at the start
    if (value == Btn.subtract && number1.isEmpty && operand.isEmpty) {
      number1 = "-";
      setState(() {});
      return;
    }

    // Handle regular value or operator input
    appendValue(value);
  }

// ##############
// calculates the result
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(3);

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

// ##############
// converts output to %
  void convertToPercentage() {
    // ex: 434+324
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

// ##############
// clears all output
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

// ##############
// delete one from the end
  void delete() {
    if (number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

// #############
// appends value to the end
  bool isResultDisplayed = false;
  void appendValue(String value) {
    // If result is currently displayed, reset the calculator for new input
    if (isResultDisplayed) {
      number1 = "";
      operand = "";
      number2 = "";
      isResultDisplayed = false;
    }

    // Check if the value is an operand (not a number or dot)
    if (value != Btn.dot && int.tryParse(value) == null) {
      // Operand pressed, if there's an existing operand and number2, perform the calculation
      if (operand.isNotEmpty && number2.isNotEmpty) {
        performCalculation();
      }
      operand = value; // Store the operand
    }
    // Assign value to number1 if operand is empty
    else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) {
        return; // Prevent multiple dots
      }
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0."; // Handle leading dot as "0."
      }
      number1 += value; // Append value to number1
    }
    // Assign value to number2 if operand is present
    else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) {
        return; // Prevent multiple dots
      }
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0."; // Handle leading dot as "0."
      }
      number2 += value; // Append value to number2
    }

    setState(() {}); // Refresh UI
  }
}
