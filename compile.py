import  os
import argparse
from dbt.cli.main import dbtRunner, dbtRunnerResult


# Argument parser for command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument("--model_name", required=True)
parser.add_argument("--profile_dir", required=True)
parser.add_argument("--env", action='append', required=False)  # Capture multiple --env arguments
args = parser.parse_args()

# Set environment variables dynamically
if args.env:
    for env_var in args.env:
        key, value = env_var.split('=', 1)
        os.environ[key] = value


# Initialize the dbt runner
dbt = dbtRunner()

# Create CLI args for the dbt command
cli_args = [
    "compile", 
    "--select", args.model_name,
    "--profile", "DEFAULT",
    "--profiles-dir", args.profile_dir,
    "--indirect-selection", "empty",
    "--partial-parse",
    "--no-fail-fast",
    "--no-cache-selected-only",
    "--no-debug",
    "--introspect",
    "--static-parser",
    "--printer-width", "80",
    "--output", "json"
]

# Run the dbt command
res: dbtRunnerResult = dbt.invoke(cli_args)
#res: dbtRunnerResult = dbt.invoke(cli_args)

# Inspect the results
