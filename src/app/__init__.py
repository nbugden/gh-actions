from flask import Flask
# Blueprints to be registered
from app.controllers.version import version as version

# Initialize flask decorator to help register blueprints
app = Flask(__name__)


@app.route('/')
def index():
    return "Demo app is live"


@app.route('/feature')
def feature():
    value = 1+1
    return f"New feature: {value == 3}"
    # return f"New feature: {value == 2}"


# @app.route('/feature2')
# def feature2():
#     value = 2+2
#     return f"New feature2: {value == 4}"


# Register blueprint(s)
app.register_blueprint(version)
