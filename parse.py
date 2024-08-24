import argparse, os
from dbt.cli.main import dbtRunner, dbtRunnerResult

# Initialize the dbt runner
dbt = dbtRunner()

# Argument parser for command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument("--profile_dir", required=True)
parser.add_argument("--env", action='append', required=False)  # Capture multiple --env arguments
args = parser.parse_args()

# Set environment variables dynamically
if args.env:
    for env_var in args.env:
        key, value = env_var.split('=', 1)
        os.environ[key] = value

cli_args = [
    "parse", 
    "--profile", "DEFAULT",
    "--indirect-selection", "eager",
    "--profiles-dir", args.profile_dir,
    "--partial-parse",
    "--no-cache-selected-only",
    "--no-fail-fast",
    "--no-debug",
    "--static-parser",
    "--printer-width", "80",
]

# Run the dbt lineage command
res: dbtRunnerResult = dbt.invoke(cli_args)

