# Captain-Slack (cptn)

![Captain-Slack](./Captain-Slack.png)

> We're living the future so the present is our past.

---

## Install


* Download source
- As root ran `bash cptn.SlackBuild`
* `upgradepkg --install-new /tmp/cptn*.tlz` 


### Uninstall

As root `removepkg cptn`

--- 

#### Usage
**create db**
1. `cptn make-db -a` Will create a full database of all installed packages and libraries (need some time...)
2. `cptn make-db -p` The same but only for packages
3. `cptn make-db -l` The same but only for libraries and their deps...

**print infos**
1. `cptn info package-name` print info for the package
2. `cptn info package-name` the same if its a library
3. `cptn open-libs` or `cptn open-pkgs` open with defauld text editor the yaml file for installed libraries or packages
4. `cptn service-status rc.service-name` print service status info
5. `cptn restart-service` print all rc.services and ask use to chose which need restart
6. `cptn show-services` export in terminal all services and their status.
7. `cptn find-mirror` check all active slackware mirrorlist servers and print the 3 faster for your location.
8. `cptn weather-forcast` print in terminal next days weather forcast for you :D (assume you are not under vpn)

---

#### Videos:
https://asciinema.org/a/5uULLvA12w3Yj69HrEqh9CNPK <br>
https://asciinema.org/a/CBgyGtqAuDwLphHhnbZubQAzq

