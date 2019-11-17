# GRaaS - Goal Reminder as a Service

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

**NOTE**: You must run `conda activate grass` before continuing! 


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