# sencha-cmd

## Basic Information

This dockerfile provides a build-environment for Sencha Apps. It is based on the [openjdk:8-jre-slim Dockerimage](https://hub.docker.com/layers/openjdk/library/openjdk/8-jre-slim/images/sha256-21288a1b9869ffc48d723a22a2091cd97567d70f459f1226630293190640604a?context=explore) and adds the following components:

* wget
* unzip
* libfreetype6
* ffontconfig
* ruby
* Apache Ant 1.10.10
* SenchaCmd 7.3.0.19

## Container Registry

This image is being built automatically through GitHub Actions and published on the GitHub Container Registry. This happens regularly every day and on pushed tags with a semantic version number (cf. [https://semver.org](https://semver.org)). If a pull-request is made against rhe main branch of this repository, it will be built but not published, though. Published images are available at [https://github.com/bwbohl/sencha-cmd/pkgs/container/sencha-cmd](https://github.com/bwbohl/sencha-cmd/pkgs/container/sencha-cmd).

## Running the image published on the GitHub Container Registry

```bash
docker run --rm -it -v /ABSOLUTE/PATH/TO/SENCHA/APP:/app --name SOME-NAME ghcr.io/bwbohl/sencha-cmd:latest
```

This will pull the pre-built image from the GitHub Container Registry and run it on your system.

## Building locally and running local image

You can clone or download this repository and then build and run the Dockerimage on your local machine. Please make sure Docker is installed on your system.

### Clone or Download

Please refer to the options GitHub is offering you above with the green button, labeled “Code”.

### Building

For building the container please run the following command, replacing SOME-NAME with a label of your liking:

```bash
docker build -t SOME-NAME .
```

e.g.


```bash
docker build -t sencha-cmd .
```

### Running

In order to run the container built according to the above instructions run the followig command, replacing SOME-NAME with the same name you used when building the container:

```bash
docker run --rm -it -v /ABSOLUTE/PATH/TO/SENCHA/APP:/app --name SOME-NAME SOME-NAME
```

Please make sure to replace ABSOLUTE/PATH/TO/SENCHA/APP with the filesystem path to your sencha app in order to mount it under `/app` in the container.

## Executing your sencha build

Either of the above ways of running the docker image will result in a `bash prompt` 'inside' the container image being opened on your commandline. Depending on your sencha-apps build environment you now should execute the respective build-commands. The standard sencha build command syntax is:

```bash
sencha app build [production|testing|native|package]
```

For more details also refer to the [Sencha Cmd Reference](https://docs.sencha.com/cmd/guides/advanced_cmd/cmd_reference.html#advanced_cmd-_-cmd_reference_-_sencha_app_build), [Using Cmd with Ext JS 6](https://docs.sencha.com/cmd/7.3.0/guides/extjs/cmd_app.html#extjs-_-cmd_app_-_building_your_application), or the [Sencha Cmd Docs](https://docs.sencha.com/cmd/7.3.0/index.html) in general.

## License

This work is licensed under the terms of the [MIT License](LICENSE).
