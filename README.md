# esp-idf-ci-action

GitHub Action for ESP32 CI

## Usage

Workflow definition

```
jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - name: Checkout repo
      uses: actions/checkout@v2
      with:
        submodules: 'recursive'
    - name: esp-idf build
      uses: espressif/esp-idf-ci-action@latest
      with:
        path: 'esp32-s2-hmi-devkit-1/examples/smart-panel'
```

## How to specify a custom version of ESP-IDF

GitHub does not support the specification of the Docker image tag as a variable.
It's the official limitation. To select the specific version of ESP-IDF you
can reference a specific version of GitHub action:

```
uses: espressif/esp-idf-ci-action@latest
uses: espressif/esp-idf-ci-action@4.2.1
uses: espressif/esp-idf-ci-action@release-v4.3
```

Each of the tags marks the corresponding branch of this repository.

## List of available tags

List based on: https://hub.docker.com/r/espressif/idf/tags

```
latest
release-v4.4
release-v4.3
release-v4.2
release-v4.1
release-v4.0
release-v3.3
v4.2.1
v4.2
v4.1.1
v4.1
v4.0.2
v3.3.4
v3.3.3
v3.3.2
v3.3.1
```

More information about supported versions of ESP-IDF: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/versions.html#support-periods

## Add a new Docker tag for the action

Docker image tags from https://hub.docker.com/r/espressif/idf/tags.
Each Docker tag is stored in branch with prefix "branch-" and has tag same as in Docker.

The new branch can be added by following the PowerShell script:

```
./Add-IdfTag.ps1 -IdfTag "v3.3.3"
```