# unorthodox-peepohug

This repo holds all the configuration required to build and deploy a simple containerized webapp on AWS AppRunner.

## The webapp

The main.go file creates a simple webserver that replies "Hello, world !", and add a custom header `Backend-Server` that contains the hostname of the server.

## The Dockerfile

The Dockerfile is a multistage build that uses the `golang` image as a builder for the webapp binary, and the `scratch` image as final image that only runs the binary and is much lighter than the `golang` image (only 3MB).

## The build pipeline

The pipeline described in `.github/workflows/main.yml` builds the docker image and pushes it to AWS Elastic Container Registry.

## The infrastructure

The infrastructure relies on AWS AppRunner to run the container image, scale it, provide SSL termination as well as load balancing.
The DNS records are managed using Cloudflare, with http to https redirect enabled for the domain.
The infrastructure is provided and updated using Terraform, with a remote state stored in S3.

## The Terraform pipeline

The pipeline described in `.github/workflows/terraform-ci.yml` will comment every pull request that contains a mofification on a terraform file with the output of the plan. When merged, the pipeline will apply the changes.
