# Captain-Slack (cptn)

![Captain-Slack](./Captain-Slack.png)

> We're living the future so the present is our past.

---

## Install

- required:`yq` and `jq`, from SBo
* DO NOT Download source.tar.gz from release but do it from branches.
- extract zip file and change in folder.
* As root ran `bash cptn.SlackBuild`
- Finally `upgradepkg --install-new /tmp/cptn*.tlz`

Alternative method (unstable):
1. `git clone https://github.com/rizitis/captain-slack.git`
2. `cd captain-slack && sudo bash cptn.SlackBuild`
3. `sudo upgradepkg --install-new /tmp/cptn*.tlz`
4. `sudo rm /tmp/cptn*.tlz`
 

### Uninstall

As root `removepkg cptn`

--- 

### Usage:

**create db**

1. `cptn make-db -a` (as root) Will create a full database of all installed packages and libraries (need some time...)
2. `cptn make-db -p` (as root) The same but only for packages
3. `cptn make-db -l` (as root) The same but only for libraries and their deps...

---
**print infos**
1. `cptn info <package-name>` Will print info for the package
2. `cptn info <package-name>` the same if its a library
3. `cptn open-libs` or `cptn open-pkgs` Defauld text editor will open with  the yaml file for installed libraries or packages (only for read)
---

**services**

1. `cptn serv-status <rc.service-name>` (as root) Will print service status info
2. `cptn restart-serv`   (as root) Will print all rc.services and ask use to chose which need restart
3. `cptn show-servs` (as root) Will export in terminal all services and their status.

---

**mirrors and weather forcast**

1. `cptn mirrors` (as root) Will check all active slackware mirrorlist servers and print top 5 (default) faster for your location.
   - `cptn mirrors -1` Using flag `-1` will print only the faster
   - `cptn mirrors -[1..9]` Valid flags numbers are from 1 to 9. (if not -N flag set, then default is 5)
2. `cptn weather` Will print in terminal next days weather forcast for you :D *(assume you are not under vpn)*
---

#### Videos:
https://asciinema.org/a/5uULLvA12w3Yj69HrEqh9CNPK <br>
https://asciinema.org/a/CBgyGtqAuDwLphHhnbZubQAzq


---

**NOTE:** main README.md as main branch it self, is the develop branch. 
<br> Some informations or commands may not exist yet for latest cptn release.<br>
Please read **release version branch README.md** for valid infos.

---

#### TODO
`cptn make coffee`

