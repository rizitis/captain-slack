import os
import subprocess
import sys

# Συνάρτηση για να διαβάσει τις εξαρτήσεις από ένα αρχείο
def read_dependencies(filename):
    dependencies = []
    try:
        with open(filename, 'r') as file:
            for line in file:
                line = line.strip()
                if line.startswith("REQUIRES="):
                    # Λήψη των εξαρτήσεων από τη γραμμή
                    reqs = line.split('=', 1)[1].strip().strip('"')
                    dependencies.extend(reqs.split())  # Προσθέτουμε τις εξαρτήσεις στη λίστα
    except FileNotFoundError:
        print(f"File {filename} not found.")
    return dependencies

# Συνάρτηση για να εκτελεί εντολές στο τερματικό
def execute_command(command):
    print(f"Executing command: {command}")
    result = subprocess.run(command, shell=True, text=True)
    if result.returncode != 0:
        print(f"Error executing command: {result.stderr}")
    else:
        print(result.stdout)

# Συνάρτηση για να βρει το .info αρχείο σε υποφακέλους
def find_info_file(package_name, base_path):
    for root, dirs, files in os.walk(base_path):
        if f"{package_name}.info" in files:
            return os.path.join(root, f"{package_name}.info")
    return None

# Αναδρομική συνάρτηση για εγκατάσταση εξαρτήσεων
def install_dependencies(package_name, base_path, installed):
    # Αν η εξάρτηση έχει ήδη εγκατασταθεί, την αγνοούμε
    if package_name in installed:
        return

    installed.add(package_name)  # Προσθέτουμε το πακέτο στη λίστα εγκατεστημένων
    info_file = find_info_file(package_name, base_path)

    if not info_file:
        print(f"{package_name}.info not found in {base_path}.")
        return

    # Διαβάζουμε τις εξαρτήσεις από το .info αρχείο
    dependencies = read_dependencies(info_file)

    if not dependencies:
        print(f"No dependencies found for {package_name}.")
        return

    # Αναστροφή της λίστας εξαρτήσεων
    dependencies.reverse()

    # Εκτέλεση εντολών για τις εξαρτήσεις
    for dependency in dependencies:
        install_dependencies(dependency, base_path, installed)  # Αναδρομική κλήση
        execute_command(f"echo Installing {dependency}")  # Αντικατάστησε με την κατάλληλη εντολή εγκατάστασης

# Κυρίως πρόγραμμα
def main():
    if len(sys.argv) < 3 or sys.argv[1] != '-i':
        print("Usage: cptn -i <package_name>")
        return

    package_name = sys.argv[2]
    base_path = "/usr/src/cptn/r/"  # Βασικός κατάλογος αναζήτησης
    installed = set()  # Λίστα για τις εγκατεστημένες εξαρτήσεις

    # Ξεκινάμε την αναδρομική εγκατάσταση των εξαρτήσεων
    install_dependencies(package_name, base_path, installed)

if __name__ == "__main__":
    main()
