<div align="center">
<h1>Grove Helm charts<br/>Path & Utilities Helm charts</h1>
<img src="https://storage.googleapis.com/grove-brand-assets/Presskit/Logo%20Joined-2.png" alt="Grove logo" width="500"/>

</div>
<br/>

![Static Badge](https://img.shields.io/badge/Maintained_by-Grove-green)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/buildwithgrove/helm-charts)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr/buildwithgrove/helm-charts)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-closed/buildwithgrove/helm-charts)

# Table of Contents <!-- omit in toc -->

- [1. Introduction](#1-introduction)
  - [1.1 Getting started](#11-getting-started)
  - [1.2 Makefile targets](#12-makefile-targets)
  - [1.3 Required packages](#13-required-packages)

## 1. Introduction

Welcome to Grove's helm repo. Here you'll find the charts to get Path up and running.

### 1.1 Getting started

To add Grove's helm repository to your local machine, run the following command:

```sh
helm repo add grove https://buildwithgrove.github.io/helm-charts
```

Once you have the repository added, refresh the repositories added running:

```sh
helm repo update
```

### 1.2 Makefile targets

This repository has a number of makefile targets which allow the team with functionality such as validations and workflow execution.

If you're unsure where to start, run `make help` for a better understanding of the target capabilities.

### 1.3 Required packages

This repo requires you to have installed the following packages:

- `helm`
- `gh`

To install them using Homebrew simply run the following command:

```sh
brew install helm gh
```

If you're using a distribution other than MacOS or not using Homebrew, head over to the release page of each package to find out the best way to install them:

- https://helm.sh/docs/intro/install/
- https://github.com/cli/cli?tab=readme-ov-file#installation