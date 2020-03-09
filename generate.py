import json
import os

__dir__ = os.path.dirname(os.path.realpath(__file__))


def read_json_file(path):
    with open(path) as f:
        return json.load(f)


def main():
    root = read_json_file(os.path.join(__dir__, "Pipfile.lock"))

    for name, pkg in root["develop"].items():
        version = pkg["version"]
        print(f"{name}{version}")

    for name, pkg in root["default"].items():
        version = pkg["version"]
        print(f"{name}{version}")


if __name__ == "__main__":
    main()
