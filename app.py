from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello_world():  # put application's code here
    return "<p>Hello, World!</p>"


@app.route('/ping/')
def ping():  # oh, no - There is a typo! this is a bug!
    return "<p>Pong!</p>"


if __name__ == '__main__':
    app.run(debug=True)
