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

### `signing_secret`

Optional: Specify the GitHub Actions Secret in order to sign the built binary by using the `espsecure.py` command.

This is useful for using GitHub Actions to generate a signed binary on a [workflow dispatch event](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch) and obtaining signed images with a couple of clicks. Also, by using this method you do not need to share private keys among developers since it will be stored as en encrypted secret.

The following example assumes that you have a GitHub Action Secret named `MY_SIGNING_KEY` and you have a `scripts` folder containing the bash scripts described below. Also, the public key that complements the private key in `MY_SIGNING_KEY` should be stored under `public/verification_key.pem`. Check [Generating Secure Boot Signing Key](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/security/secure-boot-v1.html#generating-secure-boot-signing-key) to see how to generate a private key and [Remote Signing of Images](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/security/secure-boot-v1.html#remote-signing-of-images) to understand how to extract the public key.

TLDR: private key generation and public key extraction commands:
```bash
mkdir ~/my-project-private-stuff

cd ~/my-project-private-stuff

espsecure.py generate_signing_key --version 2 signing_key.pem

espsecure.py extract_public_key --version 2 --keyfile signing_key.pem verification_key.pem
```
Remember to move the `verification_key.pem` to `your-repository/public/verification_key.pem` and add `signing_key.pem` as a GitHub Actions Secret.

The following yaml code should be placed after your build step.
```yaml
- name: Sign binary
  env:
    SIGN_KEY: ${{secrets.MY_SIGNING_KEY}}
  uses: espressif/esp-idf-ci-action@v1
  with:
    esp_idf_version: v4.4.2
    target: esp32s3
    signing_secret: "$SIGN_KEY"
    command: scripts/sign_binary.sh
- name: Verify binary signature
  uses: espressif/esp-idf-ci-action@v1
  with:
    esp_idf_version: v4.4.2
    target: esp32s3
    command: scripts/verify_binary.sh
- name: Publish artifact
  uses: actions/upload-artifact@v3
  with:
    name: my-project-signed
    path: ./build/my-project-signed.bin
```
Contents of `scripts/sign_binary.sh`:
```bash
#!/bin/bash
set -eu
echo "$SIGNING_SECRET" | espsecure.py sign_data --version 2 --keyfile /dev/stdin --output ./build/my-project-signed.bin ./build/my-project.bin
```

Contents of `scripts/verify_binary.sh`:
```bash
#!/bin/bash
set -eu
espsecure.py verify_signature --version 2 --keyfile public/verification_key.pem ./build/my-project-signed.bin
```

To trigger the workflow you should go to the `Actions` tab on your repository, find your workflow and click on the `Run workflow` button. After your workflow succeeds you should be able to download your signed binary as a `.zip` file.