# sencha-cmd

## Basic Information

This Docker image provides a build environment for Sencha ExtJS Apps. It is based on the [ruby:2.7.4-bullseye Docker image](https://hub.docker.com/layers/library/ruby/2.7.4-bullseye/images/sha256-eafd1d2e549c59ad9d7a403cd1e2f78361dc288804c9fbc012ad415ef2c3297a) and adds the following components:

* temurin-8-jre
* Apache Ant 1.10.12
* SenchaCmd Community Edition 7.0.0.40
* Sencha ExtJS GNU GPLv3 versions 5.1.1, 6.2.0, and 7.0.0 in the directory `opt/Sencha`

## Container Registry

This image is being built automatically through GitHub Actions and published on [DockerHub](https://hub.docker.com/r/bwbohl/sencha-cmd) and the [GitHub Container Registry](https://github.com/bwbohl/sencha-cmd/pkgs/container/sencha-cmd) daily and on pushed tags with a semantic version number (cf. [https://semver.org](https://semver.org)). If a pull request is issued against the main branch of this repository, it will be built but not published.

## Running the image published on the GitHub Container Registry

```bash
docker run --rm -it -v /ABSOLUTE/PATH/TO/SENCHA/APP:/app --name SOME-NAME ghcr.io/bwbohl/sencha-cmd:latest
```

The above command will pull the pre-built image from the GitHub Container Registry and run it on your system.

## Building locally and running local image

You can clone or download this repository and then build and run the Docker image on your local machine. Please make sure you have installed Docker on your system.

### Clone or Download

Please refer to the options GitHub is offering you above with the green button labelled “Code”.

### Building

For building the container, please run the following command, replacing `TAG-NAME` with a docker tag of your liking:

```bash
docker build -t TAG-NAME .
```

e.g.


```bash
docker build -t sencha-cmd:local .
```

### Running

To run the container built according to the above instructions, run the following command, replacing `TAG-NAME` with the tag name you used when executing the `docker build` command:

```bash
docker run --rm -it -v /ABSOLUTE/PATH/TO/SENCHA/APP:/app --name SOME-NAME TAG-NAME
```

Please replace /ABSOLUTE/PATH/TO/SENCHA/APP with the filesystem path to your sencha-app code to mount it under `/app` in the container.

## Executing your sencha build

Either of the above ways of running the docker image will result in a bash prompt ‘inside’ the container image opened on your command line. Depending on your sencha-app’s build environment, you now should execute the respective build commands. The standard sencha build command syntax is:

```bash
sencha app build [production|testing|native|package]
```

For more details also refer to the [Sencha Cmd Reference](https://docs.sencha.com/cmd/guides/advanced_cmd/cmd_reference.html#advanced_cmd-_-cmd_reference_-_sencha_app_build), [Using Cmd with Ext JS 6](https://docs.sencha.com/cmd/7.3.0/guides/extjs/cmd_app.html#extjs-_-cmd_app_-_building_your_application), or the [Sencha Cmd Docs](https://docs.sencha.com/cmd/7.3.0/index.html) in general.

## License

This work is licensed under the terms of the [GNU GPLv3](LICENSE).
