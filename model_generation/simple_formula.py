import tensorflow as tf
import numpy as np
import random

# Create model architecture
model = tf.keras.Sequential([
    tf.keras.layers.Dense(units=1, input_shape=[1])
])
# Create the model
model.compile(optimizer='sgd', loss='mse')

# Formula that we're going to try and predict
def formula(x):
    return 3 * x - 1

# Initialize our arrays for x and y values
xs = np.array([], dtype=float)
ys = np.array([], dtype=float)

# Generate dataset
for i in range(10000):
    i = random.randrange(-10000, 10000)
    if not (i in xs):
        xs = np.append(xs, i)
        ys = np.append(ys, formula(i))

# Normalize our data
xs = xs.reshape(-1, 1) / 10000 # n numer of 1 member arrays
ys = ys.reshape(-1, 1) / 30000 # 30,000 as max/min is +/-29,999

# x's & y's data is in range (-1, 1)

# Train our data
model.fit(xs, ys, shuffle=True, epochs=500, verbose=2)

# A nice interactive way to perform inference
#print("\nFormula: 3x - 1\n")
#n = float(input("Enter a number to predict: "))
#while n:
#    print(f"\nPredicted: {model.predict([n/10000])*30000}")
#    print(f"Actual Value: {formula(n)}\n")
#    n = float(input("Enter a number to predict: "))

# Save the model
model.save('full_model.h5')

# Convert the model to TensorFlow lite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the tflite model to a file
with tf.io.gfile.GFile('formula.tflite', 'wb') as f:
    f.write(tflite_model)
