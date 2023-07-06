import 'package:flutter/material.dart';
import 'package:tflutter/estimator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TensorFlow Lite Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // For managing our textfield where the user inputs data
  late TextEditingController _controller;
  // Our class for managing our model
  late Estimator _estimator;
  // A list of widgets for our ListBuilder (filled with prediction cards)
  late List<Widget> _children;

  // The formula our model has been trained to predict
  static const String formula = 'y = 3x - 1';
  static double formulaFunction(double x) {
    return 3 * x - 1;
  }

  @override
  void initState() {
    super.initState();
    // Initialize our controller, estimator and children fields
    _controller = TextEditingController();
    _estimator = Estimator();
    _children = [];
    // Add our explanation card first
    _children.add(explanationCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Formula Estimator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            // Our list of predictions and also explanation card
            Expanded(
              child: ListView.builder(
                itemCount: _children.length,
                itemBuilder: (_, index) {
                  return _children[index];
                },
              ),
            ),
            // Our input for user data
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(children: [
                  Expanded(
                    // The textfield for user data
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'input x\'s value here'),
                      controller: _controller,
                    ),
                  ),
                  // The button for submitting user data
                  TextButton(
                    child: const Text('Estimate'),
                    onPressed: () {
                      // Save the value and convert it to a double
                      final double x = double.parse(_controller.text);
                      // Run the prediction and save it's value
                      final double prediction = _estimator.estimate(x);
                      // Update our _children with our newest prediction
                      setState(() {
                        _children.add(
                          Dismissible(
                            key: GlobalKey(),
                            onDismissed: (direction) {},
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.amber.shade100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'X = $x',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text("Predicted Y value: $prediction"),
                                    Text(
                                        "Actual Y value: ${formulaFunction(x)}")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        // Clear our textfield after submission
                        _controller.clear();
                      });
                    },
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Simple explanation card to describe the project
  Widget get explanationCard => Dismissible(
        key: GlobalKey(),
        child: Card(
          child: Container(
            color: Colors.amber.shade900,
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I trained a simple model to predict the formula',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  formula,
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                Text(
                  'based on a dataset of x\'s and matching y\'s.\n\nTry it out below!',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
}
