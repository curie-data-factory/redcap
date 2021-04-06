# Redcap

Redcap is a proprietary CRF Research TOOL, Institut Curie **is NOT** propryetary and has no delegation to use or distribute this software.
You have to be in compliance with all requirements from the Redcap owner when you use it. Insitut Curie cannot be responsible of the use of redcap software.

It only gives you the definition file (Dockerfile) for the redcap runtime environment.

Docker Image definition for Redcap Helm deployment


## Requirements

* **You need to be a member of the Redcap Community** : [https://www.project-redcap.org/](https://www.project-redcap.org/)

* Other Requirements : [https://projectredcap.org/software/requirements/](https://projectredcap.org/software/requirements/)

## Try RedCap

To try RedCap : [https://projectredcap.org/software/try/](https://projectredcap.org/software/try/)

## Use the Docker Image

The dockerfile here gives you all the software requirements to use redcap standalone or [with our Helm Chart](https://artifacthub.io/packages/helm/curie-df-helm-charts/redcap)

To use the docker image

```bash

git clone https://github.com/curie-data-factory/redcap.git

# Copy the source code from Redcap 
cp -r redcap-sources/* ./redcap/code/redcap/

docker build -t redcap redcap
```

## Installing the helm chart

Before you can install the chart you will need to add the `curiedfcharts` repo to [https://helm.sh/](https://helm.sh/)
```bash
helm repo add curiedfcharts https://curie-data-factory.github.io/helm-charts
helm repo update
```
After you've installed the repo you can install the chart.
```bash
helm upgrade --install --namespace default --values ./my-values.yaml my-release curiedfcharts/redcap
```
