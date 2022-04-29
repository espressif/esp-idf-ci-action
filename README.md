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
      uses: espressif/esp-idf-ci-action@main
      with:
        esp_idf_version: v4.4
        target: esp32s2
        path: 'esp32-s2-hmi-devkit-1/examples/smart-panel'
```

## Parameters

### `path`

Path to the project to be built

### `esp_idf_version`

The version of ESP-IDF for the action. Default value `latest`.

It must be one of the tags from Docker Hub: https://hub.docker.com/r/espressif/idf/tags

More information about supported versions of ESP-IDF: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/versions.html#support-periods

### `target`

Type of ESP32 to build for. Default value `esp32`.

The value must be one of the supported ESP-IDF targets as documented here: https://github.com/espressif/esp-idf#esp-idf-release-and-soc-compatibility

### `command`

Optional: Specify the command that will run as part of this GitHub build step.

Default: `idf.py build`

Overriding this is useful for running other commands via github actions. Example:

```yaml
   command: esptool.py merge_bin -o ../your_final_output.bin @flash_args
```