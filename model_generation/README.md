# Model Generation

simple_formula.py contains a formula function, by default "y = 3x - 1", and it generates two large sets of 'x' and 'y' values for the model to train on. Additionally of course, it includes the model's architecture and such using Tensorflow's 'kera's integration.

Simple data normalization is performed and the model is created, before being saved and then converted to the '.tflite' format for running on movile devices, in our case IOS and Android.

# Running the script

Ensure you have any and all requirements by running the command `pip install -r requirements.txt`, and then simply run the script with `python simple_formula.py`. \
It will train the model (which might take a few seconds due to the 500 epochs), and then save it in two files, 'full_model.h5', and the optimized 'formula.tflite' which I use in the flutter app.

# Modifying

Feel free to modify the formula function in the script to try and have the model predict a different one to the default "y = 3x - 1", or even mess with the model's architecture or more. \
Just be aware that data normalization is not tied to the model file, so any changes to the data normalization will also have to be reflected in the flutter project's `estimator.dart`.
