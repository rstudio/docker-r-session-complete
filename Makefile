R_VERSION ?= 3.6.2

RSP_VERSION ?= 1.4.1106-5

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

update-versions:  ## Update the version files for all products
	@sed -i '' "s/^RSP_VERSION=.*/RSP_VERSION=${RSP_VERSION}/g" r-session-complete/bionic/.env
	@sed -i '' "s/^RSP_VERSION=.*/RSP_VERSION=${RSP_VERSION}/g" r-session-complete/centos7/.env
	@sed -i '' "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION=${RSP_VERSION}/g" r-session-complete/bionic/Dockerfile
	@sed -i '' "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION=${RSP_VERSION}/g" r-session-complete/centos7/Dockerfile
