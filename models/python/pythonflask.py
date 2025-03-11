from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/model')
def get_model():
    model = {
        "name": "John Doe",
        "age": 30,
        "email": None  # This field will be omitted in the JSON response
    }
    filtered_model = {k: v for k, v in model.items() if v is not None}
    return jsonify(filtered_model)

if __name__ == '__main__':
    app.run(debug=True)