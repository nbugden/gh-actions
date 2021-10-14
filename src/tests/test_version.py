# Defines the context in which to run the test
from app import app
# Method to be tested
from app.controllers.version import version_running
import json


def test_version():
    """
    Basic test for the version endpoint.
    Here, we make assertions for data structure and data type.
    """
    with app.app_context():
        version_result = json.loads(version_running().data)
        version_status_code = version_result['status_code']
        assert isinstance(version_result, dict)
        assert isinstance(version_status_code, int)
        assert version_status_code == 200
