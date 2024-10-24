import yaml
import subprocess
import os
import sys

base_directory = '/usr/src/captain/slack/r/'
yaml_path = '/etc/captain-slack/configs/repos.yaml'
bash_script_path = '/path/to/your_script.sh'  # Specify your bash script path here

# Function to validate priority
def validate_priority(priority):
    if isinstance(priority, int) and priority >= 0:
        return priority
    try:
        num_priority = int(priority)
        return num_priority if num_priority >= 0 else 0
    except (ValueError, TypeError):
        return 0

# Load the YAML configuration file
with open(yaml_path, 'r') as file:
    config = yaml.safe_load(file)

# Initialize flags for SBo and ponce repositories
sbo_enabled = False
ponce_enabled = False

# Process the repositories
for repo in config['resources']['repositories']:
    repo_name = repo['repository']
    repo_url = repo['url']
    repo_branch = repo.get('branch', 'main')
    repo_priority = validate_priority(repo.get('priority'))
    repo_type = repo.get('type')

    # Check for SBo and ponce conditions
    if repo_name == 'SBo' and repo_priority > 0:
        sbo_enabled = True
    if repo_name == 'ponce' and repo_priority > 0:
        ponce_enabled = True

    # If both repositories are enabled, print a message and exit
    if sbo_enabled and ponce_enabled:
        print("You can't have both SBo and ponce repositories enabled. One of them must be disabled (priority: 0).")
        sys.exit(1)

    repo_path = os.path.join(base_directory, repo_name)
    
    # Create directory if it doesn't exist
    if not os.path.exists(repo_path):
        os.makedirs(repo_path)

    # Update or clone for git repositories
    if repo_type == 'git' and repo_priority > 0:
        try:
            subprocess.run(['git', 'rev-parse', '--is-inside-work-tree'], check=True, cwd=repo_path)
            subprocess.run(['git', 'pull', 'origin', repo_branch], check=True, cwd=repo_path)
        except subprocess.CalledProcessError:
            subprocess.run(['git', 'clone', '--depth', '1', repo_url, repo_path, '-b', repo_branch], check=True)
    
    # Call the Bash script for web repositories
    elif repo_type == 'web' and repo_priority > 0:
        print(f"Calling bash script for repository {repo_name}.")
        subprocess.run([bash_script_path], check=True)  # Only calling the bash script without arguments because every repo has its own structure

print("The update process has completed.")
