import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';

// Estimator class to handle the model
class Estimator {
  // Where our model file is stored
  final String _modelFile = 'assets/formula.tflite';
  // The interpreter will be an instance of our model
  late Interpreter _interpreter;

  Estimator() {
    // Load model when the Estimator is initialized
    _loadModel();
  }

  // Method for loading the model
  void _loadModel() async {
    // Customizing the behaviour of our interpreter
    final InterpreterOptions options = InterpreterOptions();

    // XNNPackDelegate uses the XNNPACK library to optimize performance on android
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }
    // Leverage the device's GPU on IOS
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Create the interpreter from our tflite asset model
    _interpreter = await Interpreter.fromAsset(_modelFile, options: options);

    print('Interpreter loaded successfully!');
  }

  // Method for running an inference with our model
  double estimate(double x) {
    // You must ensure your input and output tensor shapes are identical to those
    // that your model is compatible with.

    // Cheeky bit of normalization
    x = x / 10000;

    // Put our input data into a 1D tensor
    List<double> input = [x];
    // Prepare our output tensor into a 2D tensor
    List<dynamic> output = List<double>.filled(1, 0).reshape([1, 1]);
    // Perform the inference (run the value through our model)
    _interpreter.run(input, output);
    // Return the output value we got
    return output[0][0] * 30000; // * 30,000 is due to normalization again
  }
}
