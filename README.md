# sencha-cmd

## Basic Information

This dockerfile provides a build-environment for Sencha Apps. It is based on the `openjdk:8-jre-slim` Dockerimage and adds the following components:

* wget
* unzip
* libfreetype6
* ffontconfig
* ruby
* Apache Ant 1.10.10
* SenchaCmd 7.3.0.19

## building

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
docker run --rm -it -v ABSOLUTE/PATH/TO/SENCHA/APP:/app --name SOME-NAME SOME-NAME
```

Please make sure to replace ABSOLUTE/PATH/TO/SENCHA/APP with the filesystem path to your sencha app in order to mount it under `/app` in the container.


## License

This work is licensed under the terms of the [MIT License](LICENSE).
