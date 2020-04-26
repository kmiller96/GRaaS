# GRaaS - Goal Reminder as a Service

## Introduction
The solution architecture diagram can be found at `docs/diagram.png`. This is
a programmatically generated diagram using the awesome 
[diagrams](https://github.com/mingrammer/diagrams) package by mingrammer. If you
need to regenerate the diagram for any particular reason you can run the 
following command:

```bash
make diagram
```

## Installation
The following dependencies are required in your local environment:

- Terraform
- Anaconda/Miniconda

You will also need your own AWS account to deploy the code into. For this
deployment we assume that you are using your default AWS account.

To install GRaaS into your environment, simply run the following command:

```bash
make init
```

This will install a new python environment called `grass` and initialise 
Terraform in the `infrastructure/` directory.

**NOTE**: You must run `conda activate graas` before continuing! 


## Configuration
You can control the goals that are texted to you via the `config/goals.json` 
file. Once you've made your appropriate change you can commit these changes
via the command:

```bash
make update
```

this will update the goals for the next execution run.


## Tests
To run the testing suite run the following command with your conda environment 
activated:

```bash
make tests
```