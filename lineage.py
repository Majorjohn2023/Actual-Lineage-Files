import sys
from dbt.cli.main import dbtRunner, dbtRunnerResult

# Initialize the dbt runner
dbt = dbtRunner()

# Accept the model name as a command-line argument
model_name = sys.argv[1] if len(sys.argv) > 1 else ""
profile_dir = sys.argv[2] if len(sys.argv) > 2 else ""

print(f"Model name: {model_name}")


cli_args = [
    "ls", 
    "--select", model_name, 
    "--profile", "DEFAULT",
    "--profiles-dir", profile_dir,
    "--resource-type", "model", 
    "--resource-type", "source", 
    "--resource-type", "snapshot", 
    "--resource-type", "seed", 
    "--resource-type", "exposure",

    "--partial-parse",
    "--no-cache-selected-only",
    "--no-debug",
    "--static-parser",
    "--printer-width", "80",
    "--output", "json",
]

# Run the dbt lineage command
res: dbtRunnerResult = dbt.invoke(cli_args)

# Check if the command was successful and print the appropriate message
if res.success:
    print("Command executed successfully")
else:
    print(f"Command failed with error: {res.exception}")
