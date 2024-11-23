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
  - [1.2 Setup pre-commit hooks](#12-setup-pre-commit-hooks)

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

### 1.2 Setup pre-commit hooks

Helm charts repo uses pre-commit hooks to check for local changes before they are pushed into any remote branch.

To setup pre-commit, simply run the following command:

```sh
brew install pre-commit
```

If you prefer to install using `pip`, run the following command:

```sh
pip install pre-commit
```