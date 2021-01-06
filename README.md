# Process SNAP GPT graphs using docker and the Common Workflow Language (CWL)

## TODO

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

This repo provides a method to process Earth Observation data with the SNAP Graph Processing Tool (GPT) using docker and CWL.

With this method, the host machine does not have to have SNAP installed. 

CWL is used to invoke the SNAP `gpt` command line tool and deals with all the docker volume mounts required to process a Graph and EO data available on the host.

This repo contains a SNAP Graph for the SAR calibration of Copernicus Sentinel-1 GRD product. You're expected to have the product on your local computer

## Installation

If not done yet, install `docker` and `cwltool`.

## Execution

### Option 1: using the provided SNAP docker image under this organization

Choose this option if you want to use the provided SNAP docker image under https://github.com/snap-contrib/docker-snap/packages/561541

Choose this option if you want to build the docker image yourself using the CWL document `build-run-gpt.cwl` provided.

1. Login on Github docker repository

The docker used in this option is published on Github Packages. 

If you don't have a Personal Access Token with `read:packages` set, create a new one at: https://github.com/settings/tokens/new

Log on the docker repository with:

```console
docker login docker.pkg.github.com --username <your_user_name> --password <generated_token_not_password>
```

2. Clone this repository 

3. Update the parameters file `safe` list of products to process. The example provided does the Sentinel-1 GRD calibration.

```yaml
context: {'class': 'Directory', 'path': './'}
dockerfile: {'class': 'File', 'path': '.docker/Dockerfile'}
polarization: 'VV'
snap_graph: {class: File, path: ./sar-calibration.xml}
safe:
- {'class': 'Directory', 'path': './S1A_IW_GRDH_1SDV_20201228T170552_20201228T170617_035889_0433FB_D8C7.SAFE/'}
```

The file `./sar-calibration.xml` contains a SNAP Graph.

4. Run the SNAP graph with CWL: 

```console
cwltool --no-read-only run-gpt-sar-calibration.cwl  params.yml
```

The CWL tool will pull the image if needed.

### Option 2: build and use a local docker image 

Choose this option if you want to build the docker image yourself using the CWL document `build-run-gpt.cwl` provided.

1. Clone this repository 

2. Update the parameters file `safe` list of products to process. The example provided does the Sentinel-1 GRD calibration

```yaml
context: {'class': 'Directory', 'path': './'}
dockerfile: {'class': 'File', 'path': '.docker/Dockerfile'}
polarization: 'VV'
snap_graph: {class: File, path: ./sar-calibration.xml}
safe:
- {'class': 'Directory', 'path': './S1A_IW_GRDH_1SDV_20201228T170552_20201228T170617_035889_0433FB_D8C7.SAFE/'}
```

The file `./sar-calibration.xml` contains a SNAP Graph.

3. Run the SNAP graph with CWL: 

In a terminal, run:

```console
cwltool --no-read-only build-run-gpt.cwl params.yml
```

## Run your own SNAP graphs

Use the approach provided to run your own SNAP graphs

1. Create your own repo with this one as a template using the URL https://github.com/snap-contrib/cwl-snap-graph-runner/generate

2. Create the SNAP graphs

3. Write the CWL document to expose the SNAP Graph parameters you want to provide at execution time

4. Write the YAML parameters file 

5. Run the CWL document
