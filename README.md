# esp-idf-ci-action

This GitHub action helps to build ESP-IDF projects for the Espressif ESP32 family of chips.

Under the hood, it wraps the official [ESP-IDF docker image](https://hub.docker.com/r/espressif/idf) and uses Docker to execute ESP-IDF commands within a containerized environment. Therefore, it must run on a runner that supports Linux Docker containers. We recommend using `ubuntu-latest` on GitHub-hosted runner.

## Usage

An example workflow to build an ESP-IDF project:

```
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repo
      uses: actions/checkout@v4
      with:
        submodules: 'recursive'
    - name: esp-idf build
      uses: espressif/esp-idf-ci-action@v1
      with:
        esp_idf_version: v4.4
        target: esp32s2
        path: 'esp32-s2-hmi-devkit-1/examples/smart-panel'
```

## Version

We recommend referencing this action as `espressif/esp-idf-ci-action@v1` and using `v1` instead of `main` to avoid breaking your workflows. `v1` tag always points to the latest compatible release.

## Parameters

### `path`

Path to the project to be built relative to the root of your repository.

### `esp_idf_version`

The version of ESP-IDF for the action. Default value `latest`.

It must be one of the tags from Docker Hub: https://hub.docker.com/r/espressif/idf/tags

More information about supported versions of ESP-IDF: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/versions.html#support-periods

### `esp_idf_docker_image`

The base image for the docker container to run. Default value `espressif/idf`

If using a modified or self-hosted version of the IDF. The `esp_idf_version` will still be used to specify the tag of the docker image, so setting both can be used to directly specify which docker image to use.

### `extra_docker_args`

Additional parameters to pass to the docker run command. Default value is no additional command (empty).

The argument is passed directly to the docke run command, just before the specification of the docker image.

Can be used to add additional volumes and environment variables to the container, like having a ccache directory to speed up recompilation (needs ccache to be installed in the specified docker image and make sure to have ccache folder available on host device). Example:

```yaml
extra_docker_args: -v ./.ccache:/root/.ccache -e CCACHE_DIR=/root/.ccache
```

More information about parameters for docker run: https://docs.docker.com/reference/cli/docker/container/run/

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
