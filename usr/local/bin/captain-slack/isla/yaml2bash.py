#!/usr/bin/env python3
import yaml
import sys

yaml_file = "/etc/captain-slack/configs/repos.yaml"

with open(yaml_file, 'r') as file:
    config = yaml.safe_load(file)

repositories = config['resources']['repositories']

for repo in repositories:
    repo_name = repo['repository']
    repo_type = repo['type']
    repo_url = repo['url']
    repo_priority = repo.get('priority', 0)
    
    # Only proceed if the repository is of type 'web' and priority is greater than 0
    if repo_priority > 0 and repo_type == 'web':
        # Print variables in "key=value" format
        print(f"REPO_NAME={repo_name}")
        print(f"REPO_TYPE={repo_type}")
        print(f"REPO_URL={repo_url}")
        print(f"REPO_PRIORITY={repo_priority}")
        
        # Print other optional fields if they exist
        repo_arch = repo.get('arch', [])
        if repo_arch:
            print(f"REPO_ARCH={','.join(repo_arch)}")
        
        repo_branches = repo.get('branches', [])
        if repo_branches:
            print(f"REPO_BRANCHES={','.join([branch['name'] for branch in repo_branches])}")
        
        repo_pkg_structure = repo.get('pkg_structure', '')
        if repo_pkg_structure:
            print(f"REPO_PKG_STRUCTURE={repo_pkg_structure}")
        
        repo_tag = repo.get('tag', '')
        if repo_tag:
            print(f"REPO_TAG={repo_tag}")

        print("")  # Add a blank line to separate repositories
