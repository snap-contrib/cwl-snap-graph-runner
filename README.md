# Process SNAP GPT graphs using docker and the Common Workflow Language (CWL)

## TODO

This repo provides a method to process Earth Observation data with the SNAP Graph Processing Tool (GPT) using docker and CWL.

With this method, the host machine does not have to have SNAP installed. 

CWL is used to invoke the SNAP `gpt` command line tool and deals with all the docker volume mounts required to process a Graph and EO data available on the host.

This repo contains a SNAP Graph for the SAR calibration of Copernicus Sentinel-1 GRD product. You're expected to have the product on your local computer

## Installation

If not done yet, install `docker` and `cwltool`.

## Option 1: using the provided SNAP docker image under this organization

```console
cwltool --no-read-only sar-calibration.cwl params.yml
```

## Option 2: build a custom docker image 

```console
cwltool --no-read-only sar-calibration-custom-docker.cwl params.yml
```
