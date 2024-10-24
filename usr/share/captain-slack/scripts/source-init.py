import configparser
import os

# Read the config file
config = configparser.ConfigParser()
config.read('your_config_file.ini')

# Function to resolve and export all variables automatically
def source_config():
    for section in config.sections():
        for key in config[section]:
            value = config[section][key]
            resolved_value = os.path.expandvars(value)  # Resolve variables like $APP_HOME
            os.environ[key] = resolved_value  # Export to environment
            print(f"{key} = {resolved_value}")  # Automatically echo the key-value pair

# Call the function to source the config
source_config()

