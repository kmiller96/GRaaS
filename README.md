# GRaaS

Get reminded about your goals the easy way! Get them sent to you on a regular
basis to make sure you know what you should be doing with your life.

## Usage
In the current version, you are only able to update your specific goals. The
delivery timing, delivery cadence, and delivery medium are all fixed.

Start by tweaking the variables in `config/terraform.tfvars.json`. You **must**
change the `goal_bucket_name` as these are unique across all of AWS. Feel free
to change some fo the other parameters too.

If you'd like to change your goals prior to deploying the application, tweak
the contents of `config/goals.json`. To change your goals after deployment,
you can defining a JSON file of the following structure:

```json
{
    "weekly": [
        "goal1",
        "goal2",
        ...
    ],
    "monthly": [
        "goal1",
        "goal2",
        ...
    ]
}
```

and run the command:

```bash
graas update <fpath>
```


## Installation
If you are happy with the default options for everything and want to get started
quickly you can run the following utility:

```bash
make install
```

There are two main installation components of GRaaS:

### CLI
This is the interface of the system. It enables the quick configuration of
goals without having to leave the terminal. The CLI is installed via pip:

```bash
pip install <project path>
```

where the `<project path>` is the path the cloned GRaaS project. You can also
run the `make cli` command.

### Infrastructure 
This is an out-of-the-box system. Terraform has been written to quickly deploy
a set of lambdas into your AWS environment. A set of `make` utilities have been
created to make this process easier. Deploying the AWS environment is done via:

```bash
make deploy
```

You can also run these utilities manually with the commands `make init`, 
`make build`, and `make infrastructure` which can be helpful during debugging.

