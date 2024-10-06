import 'package:yuukacalculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/hayase_yuuka.jpg'), // Image path
              fit: BoxFit.cover, // Cover the entire background
              alignment:
                  const Alignment(0.4, 0), // Move image slightly to the left
              colorFilter: ColorFilter.mode(
                Colors.black
                    .withOpacity(0.7), // Adjust brightness (dark overlay)
                BlendMode.darken, // Use darken mode for brightness adjustment
              ),
            ),
          ),
          constraints: const BoxConstraints(),
          child: Column(
            children: [
              // Display Section
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      "0000000000000000000000000",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(
                            255, 236, 161, 255), // White text for contrast
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0), // Add padding around the button
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(10), // Clip the button to the border radius
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent button background
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
              onTap: () {},
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
}
